
syms  a Q  x I11 I22 I1 I2 m1 m2 a1 a2 R01 R12 Q1 Q2 R01T  R12T PC00 PC01 PC12 PC02 X Y L1 L2 X_DOT Y_DOT Z0 Z1 O1 O2  M   Z2 gc g gt G1 G2 Q1DOT Q2DOT j k Q1DOT2 Q2DOT2
T1=zeros(1,5)
T2=zeros(1,5)

for i=1:5
   x=i

% x=5;      
%time
gc=9.81;    %gravity
m={0.704,0.201};   %link  mass
a1=0.310;   %link 1 length
a2=0.152;   %link 2 length

q1=Q1(x)
q2=Q2(x)
I11=(1/12*m{1}*a1^2)*[0 0 0; 0 1 0; 0 0 1;]       %link 1 inertia matrix
I22=(1/12*m{2}*a2^2)*[0 0 0; 0 1 0; 0 0 1;]       %link 2 inertia matrix
R01=[cos(Q1(x)) -sin(Q1(x)) 0 ; sin(Q1(x)) cos(Q1(x)) 0 ; 0 0 1 ;]      
R12=[cos(Q2(x)) -sin(Q2(x)) 0 ; sin(Q2(x)) cos(Q2(x)) 0 ; 0 0 1 ;]
R02=R01*R12
R01T=transpose(R01)
R02T=transpose(R02)
I={R01*I11*R01T,R02*I22*R02T}

% The position vectors of the centers of mass of link 1 and 2.
PC00=[0;0;0]
PC01=[a1/2*cos(Q1(x)); a1/2*sin(Q1(x)); 0;]
PC12=[a2/2*(cos(Q1(x))*cos(Q2(x)) - sin(Q1(x))*sin(Q2(x))); a2/2*(cos(Q1(x))*sin(Q2(x)) + cos(Q2(x))*sin(Q1(x))); 0;]
PC02=[a1*cos(Q1(x)) + a2/2*(cos(Q1(x))*cos(Q2(x)) - sin(Q1(x))*sin(Q2(x))); a1*sin(Q1(x)) + a2/2*(cos(Q1(x))*sin(Q2(x)) + cos(Q2(x))*sin(Q1(x))); 0;]

Z0=[0;0;1]
Z1=[0;0;1]

% The link Jacobian Submatrices Jvi Jwi
Jv={[cross(Z0,(PC01-PC00)) cross(Z1,PC00)],[cross(Z0,(PC02-PC00)) cross(Z1,(PC12-PC00))]}
Jw={[0 0; 0 0; 1 0;],[0 0; 0 0;1 1;]}

JvT = {transpose(Jv{1}),transpose(Jv{2})};
JwT = {transpose(Jw{1}),transpose(Jw{2})};

%Manipulator inertia matrix
n=2;
M=msum(n,Jv,Jw,m,I,JwT,JvT)

%Velocity coupling vector
V = {-m{2}*a1*a2*sin(Q2(x))*(Q1DOT(x)*Q2DOT(x) + 0.5*Q2DOT(x)^2),(1/2)*m{2}*a1*a2*sin(Q2(x))*Q1DOT(x)^2}


%Gravitational vector
g=[0;gc;0]
gt=transpose(g)
G1=gt*[m{1}*Jv{1}(:,1) + m{2}*Jv{2}(:,1)]
G2=gt*[m{1}*Jv{1}(:,2) + m{2}*Jv{2}(:,2)]

%Lagrange's Equations of motion
T1(i)=M(1,1)*Q1DOT2 + M(1,2)*Q2DOT2 + V{1}+ G1 
T2(i)=M(2,1)*Q1DOT2 + M(2,2)*Q2DOT2 + V{2} + G2 
n=2;
% mont_DataFile;
% mont;
%functions

end
t=1:5
figure(1)
plot(t,T1,'bo-')
title('Joint 1')
xlabel('Time(Sec)')
ylabel('Torque(Nm)')
figure(2)
plot(t,T2,'ro-')
title('Joint 2')
xlabel('Time(Sec)')
ylabel('Torque(Nm)')

function Mi=Minertia(jv,jw,m,I,jwT,jvT)

Mi=(jvT*m*jv + jwT*I*jw)

end

function Msum=msum(n,Jv,Jw,m,I,JwT,JvT)
Msum=0;
for i=1:n 
    Msum=Msum + Minertia(Jv{i},Jw{i},m{i},I{i},JwT{i},JvT{i})
end
end


function Q = Q1(x)
    Q = (x^2+3*x+1)*(pi/180);
end

function Q = Q1DOT(x)
    Q = 0;        % bunlar 0 çünkü  hız yok sabit olarak alıyoruz.
   
end

function Q = Q1DOT2(x)
    Q = 0;
 
end

function Q = Q2(x)
    Q = (x^2+2*x+1)*(pi/180);
end

function Q = Q2DOT(x)
    Q = 0;
end

function Q = Q2DOT2(x)
    Q = 0;
end
