#include "untitled.h"
#include "rtwtypes.h"
#include <ext_work.h>
#include <ext_svr.h>
#include <ext_share.h>
#include <updown.h>

volatile int IsrOverrun = 0;
boolean_T isRateRunning[2] = { 0, 0 };

boolean_T need2runFlags[2] = { 0, 0 };

void rt_OneStep(void)
{
  boolean_T eventFlags[2];

  /* Check base rate for overrun */
  if (isRateRunning[0]++) {
    IsrOverrun = 1;
    isRateRunning[0]--;                /* allow future iterations to succeed*/
    return;
  }

  /*
   * For a bare-board target (i.e., no operating system), the rates
   * that execute this base step are buffered locally to allow for
   * overlapping preemption.  The generated code includes function
   * writeCodeInfoFcn() which sets the rates
   * that need to run this time step.  The return values are 1 and 0
   * for true and false, respectively.
   */
  untitled_SetEventsForThisBaseStep(eventFlags);

#ifndef _MW_ARDUINO_LOOP_

  sei();

#endif;

  untitled_step0();

  /* Get model outputs here */
#ifndef _MW_ARDUINO_LOOP_

  cli();

#endif;

  isRateRunning[0]--;
  if (eventFlags[1]) {
    if (need2runFlags[1]++) {
      IsrOverrun = 1;
      need2runFlags[1]--;              /* allow future iterations to succeed*/
      return;
    }
  }

  if (need2runFlags[1]) {
    if (isRateRunning[1]) {
      /* Yield to higher priority*/
      return;
    }

    isRateRunning[1]++;

#ifndef _MW_ARDUINO_LOOP_

    sei();

#endif;

    /* Step the model for subrate "1" */
    switch (1)
    {
     case 1 :
      untitled_step1();

      /* Get model outputs here */
      break;

     default :
      break;
    }

#ifndef _MW_ARDUINO_LOOP_

    cli();

#endif;

    need2runFlags[1]--;
    isRateRunning[1]--;
  }

  rtExtModeCheckEndTrigger();
}

volatile boolean_T stopRequested;
volatile boolean_T runModel;
int main(void)
{
  float modelBaseRate = 0.1;
  float systemClock = 0;

  /* Initialize variables */
  stopRequested = false;
  runModel = false;
  init();
  MW_Arduino_Init();
  rtmSetErrorStatus(untitled_M, 0);

  /* initialize external mode */
  rtParseArgsForExtMode(0, NULL);
  untitled_initialize();
  cli();
  sei ();

  /* External mode */
  rtSetTFinalForExtMode(&rtmGetTFinal(untitled_M));
  rtExtModeCheckInit(2);

  {
    boolean_T rtmStopReq = false;
    rtExtModeWaitForStartPkt(untitled_M->extModeInfo, 2, &rtmStopReq);
    if (rtmStopReq) {
      rtmSetStopRequested(untitled_M, true);
    }
  }

  rtERTExtModeStartMsg();
  cli();
  configureArduinoAVRTimer();
  runModel =
    (rtmGetErrorStatus(untitled_M) == (NULL)) && !rtmGetStopRequested(untitled_M);

#ifndef _MW_ARDUINO_LOOP_

  sei();

#endif;

  sei ();
  while (runModel) {
    /* External mode */
    {
      boolean_T rtmStopReq = false;
      rtExtModeOneStep(untitled_M->extModeInfo, 2, &rtmStopReq);
      if (rtmStopReq) {
        rtmSetStopRequested(untitled_M, true);
      }
    }

    stopRequested = !(
                      (rtmGetErrorStatus(untitled_M) == (NULL)) &&
                      !rtmGetStopRequested(untitled_M));
    runModel = !(stopRequested);
    MW_Arduino_Loop();
  }

  /* Disable rt_OneStep() here */

  /* Terminate model */
  untitled_terminate();
  rtExtModeShutdown(2);
  cli();
  return 0;
}
