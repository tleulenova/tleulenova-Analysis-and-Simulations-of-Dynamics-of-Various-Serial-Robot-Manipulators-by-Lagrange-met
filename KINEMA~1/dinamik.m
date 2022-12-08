syms  I11 I22 I1 I2 m1 m2 a1 a2 R01 R12 Q1 Q2 R01T R12T PC00 PC01 PC12 PC02 X Y L1 L2 X_DOT Y_DOT Z0 Z1 O1 O2 Jvi Jwi M Jv1T Jv2T Jw1T Jw2T  Z2 gc g gt G1 G2 Q1DOT Q2DOT j k Q1DOT2 Q2DOT2 i 

I11=(1/12*m1*a1^2)*[0 0 0; 0 1 0; 0 0 1;]
I22=(1/12*m2*a2^2)*[0 0 0; 0 1 0; 0 0 1;]
R01=[cos(Q1) -sin(Q1) 0 ; sin(Q1) cos(Q1) 0 ; 0 0 1 ;]
R12=[cos(Q2) -sin(Q2) 0 ; sin(Q2) cos(Q2) 0 ; 0 0 1 ;]
R02=R01*R12
R01T=transpose(R01)
R02T=transpose(R02)
I1=R01*I11*R01T
I2=R02*I22*R02T
simplify(I2)

% The position vectors of the centers of mass of link 1 and 2.
PC00=[0;0;0]
PC01=[a1/2*cos(Q1); a1/2*sin(Q1); 0;]
PC12=[a2/2*(cos(Q1)*cos(Q2) - sin(Q1)*sin(Q2)); a2/2*(cos(Q1)*sin(Q2) + cos(Q2)*sin(Q1)); 0;]
PC02=[a1*cos(Q1) + a2/2*(cos(Q1)*cos(Q2) - sin(Q1)*sin(Q2)); a1*sin(Q1) + a2/2*(cos(Q1)*sin(Q2) + cos(Q2)*sin(Q1)); 0;];
PC02=simplify(PC02)
Z0=[0;0;1]
Z1=[0;0;1]

% The link Jacobian Submatrices Jvi Jwi
Jv1=[cross(Z0,(PC01-PC00)) cross(Z1,PC00)]
Jw1=[0 0; 0 0; 1 0;]
Jv2=[cross(Z0,(PC02-PC00)) cross(Z1,(PC12-PC00))];
Jv2=simplify(Jv2)
Jw2=[0 0; 0 0;1 1;]
Jv1T = transpose(Jv1);
Jv2T = transpose(Jv2);
Jw1T = transpose(Jw1);
Jw2T = transpose(Jw2);

%Manipulator inertia matrix
M=Jv1T*m1*Jv1 + Jw1T*I1*Jw1 + Jv2T*m2*Jv2 + Jw2T*I2*Jw2 ;
M=simplify(M)

%Velocity coupling vector
V1 = -m2*a1*a2*sin(Q2)*(Q1DOT*Q2DOT + 1/2*Q2DOT^2)
V2 = (1/2)*m2*a1*a2*sin(Q2)*Q1DOT^2

%Gravitational vector
g=[0;gc;0]
gt=transpose(g)
G1=gt*[m1*Jv1(:,1) + m2*Jv2(:,1)]
pretty(G1)
G2=gt*[m1*Jv1(:,2) + m2*Jv2(:,2)]
pretty(G2)

%Lagrange's Equations of motion
T1=M(1,1)*Q1DOT2 + M(1,2)*Q2DOT2 + V1 + G1  ;
T1=simplify(T1)
pretty(T1)
T2=M(2,1)*Q1DOT2 + M(2,2)*Q2DOT2 + V2 + G2  ;
T2=simplify(T2)
pretty(T2)


