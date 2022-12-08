%inverse kinematics
syms L1 L2 theta1 theta2 X Y K1 K2
L1=0.310;  % length of link 1
L2=0.152;  % length of link 2   
X= 0.2682; % position of actuator x direction
Y= 0.3515; % position of actuator y direction
%Show the pair of solutions for theta2
theta2=atan2(+(1-((X^2+Y^2-L1^2-L2^2)/(2*L1*L2))^2)^0.5,(X^2+Y^2-L1^2-L2^2)/(2*L1*L2));
%Show the pair of solutions for theta1
K1=L1 + L2*cos(theta2);
K2=L2*sin(theta2);
theta1=atan2(Y,X)- atan2(K2,K1);
%Show the pair of solutions for Joint angles
JointAngles = [theta1*(180/pi) theta2*(180/pi)] 
