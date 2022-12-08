syms L1 L2 theta1 theta2 X Y 
L1=0.310;   % length of link 1
L2=0.152;   % length of link 2
theta1=41*(pi/180); %   orientation of joint 1
theta2=36*(pi/180); %   orientation of joint 2

 % Define X and Y Coordinates of End Effector
 X_RHS=L1*cos(theta1)+L2*cos(theta1+theta2); 
 Y_RHS=L1*sin(theta1)+L2*sin(theta1+theta2);
 
X_and_Y=[X_RHS Y_RHS]