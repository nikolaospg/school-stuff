clc
clear
close all

%This script show the results from the bisection method (without the derivative)

%Using function handles to initialise the objective functions
f1=@(x)( (x-3).^2 +(sin(x+3)).^2 );
f2=@(x)( (x-1).*cos(x/2) + x.^2);
f3=@(x)( (x+2).^2 + exp(x-2) .* (sin(x+3)));
%Finished initialising the functions to be minimised

%Algorithm Parameters
a=-4;
b=4;
l=0.01;
e=0.001;

%First Applying the algorithm for the parameters I just initialised.
[a_vector1, b_vector1, k1, f_comp1] = bisection(f1, a, b, l, e);
[a_vector2, b_vector2, k2, f_comp2] = bisection(f2, a, b, l, e);
[a_vector3, b_vector3, k3, f_comp3]= bisection(f3, a, b, l, e);

%Finished working with the initial parameters

%Now, holding l=0.01 constant I change the e values and get results
%Of course l>2e <=> e<l/2, therefore e must be <0.005
initial_e=0.0001;
step_e=0.00005;
final_e=0.005-0.0001;
varying_e=initial_e:step_e:final_e;

f1_comps_e=zeros(1,length(varying_e));
f2_comps_e=zeros(1,length(varying_e));
f3_comps_e=zeros(1,length(varying_e));
for i=1:length(varying_e)
    [~,~,~,f1_comps_e(i)]=bisection(f1,a,b,l, varying_e(i));
    [~,~,~,f2_comps_e(i)]=bisection(f2,a,b,l, varying_e(i));
    [~,~,~,f3_comps_e(i)]=bisection(f3,a,b,l, varying_e(i));
end

figure("Name","Number of f1 computations for l=0.01, various e values")
plot(varying_e, f1_comps_e)
xlabel("e values")
ylabel("Number of f1 computations")

figure("Name","Number of f2 computations for l=0.01, various e values")
plot(varying_e, f2_comps_e)
xlabel("e values")
ylabel("Number of f2 computations")

figure("Name","Number of f3 computations for l=0.01, various e values")
plot(varying_e, f3_comps_e)
xlabel("e values")
ylabel("Number of f3 computations")
%Finished with the varying e


%Now, for e=0.001 constant, I change the l values and get the results
%Of course l>2e <=> l>0.002. Of course l<b-a!!
initial_l=0.01;
step_l=0.005;
final_l=(b-a)/2;
varying_l=initial_l:step_l:final_l;

f1_comps_l=zeros(1,length(varying_l));
f2_comps_l=zeros(1,length(varying_l));
f3_comps_l=zeros(1,length(varying_l));
for i=1:length(varying_l)
    [~,~,~,f1_comps_l(i)]=bisection(f1,a,b,varying_l(i), e);
    [~,~,~,f2_comps_l(i)]=bisection(f2,a,b,varying_l(i), e);
    [~,~,~,f3_comps_l(i)]=bisection(f3,a,b,varying_l(i), e);
end


figure("Name","Number of f1 computations for e=0.001, various l values")
plot(varying_l, f1_comps_l)
xlabel("l values")
ylabel("Number of f1 computations")

figure("Name","Number of f2 computations for e=0.001, various l values")
plot(varying_l, f2_comps_l)
xlabel("l values")
ylabel("Number of f2 computations")

figure("Name","Number of f3 computations for e=0.001, various l values")
plot(varying_l, f3_comps_l)
xlabel("l values")
ylabel("Number of f3 computations")
%Finished with the varying l


%Now, for a varying l I will find the (n,an) (n,bn), where n is the final k value of every iteration
n1_vector=zeros(1, length(varying_l));
n2_vector=zeros(1, length(varying_l));
n3_vector=zeros(1, length(varying_l));

an1=zeros(1, length(varying_l));
an2=zeros(1, length(varying_l));
an3=zeros(1, length(varying_l));

bn1=zeros(1, length(varying_l));
bn2=zeros(1, length(varying_l));
bn3=zeros(1, length(varying_l));

for i=1:length(varying_l)
    [a1_vector_n, b1_vector_n, n1 ,~]=bisection(f1,a,b,varying_l(i), e);
    [a2_vector_n, b2_vector_n, n2 ,~]=bisection(f2,a,b,varying_l(i), e);
    [a3_vector_n, b3_vector_n, n3 ,~]=bisection(f3,a,b,varying_l(i), e);
    
%     n1_vector(i)=n1;
%     n2_vector(i)=n2;
%     n3_vector(i)=n3;
    
    an1(i)=a1_vector_n(end);
    an2(i)=a2_vector_n(end);
    an3(i)=a3_vector_n(end);
    
    bn1(i)=b1_vector_n(end);
    bn2(i)=b2_vector_n(end);
    bn3(i)=b3_vector_n(end);
end

figure("Name","(n,an) and (n,bn) for various l, f1")
plot(varying_l, an1);
hold on
plot(varying_l, bn1)
xlabel("l values")
ylabel("a(n), b(n)")
legend("a(n)","b(n)")

figure("Name","(n,an) and (n,bn) for various l, f2")
plot(varying_l, an2);
hold on
plot(varying_l, bn2)
xlabel("l values")
ylabel("a(n), b(n)")
legend("a(n)","b(n)")

figure("Name","(n,an) and (n,bn) for various l, f3")
plot(varying_l, an3);
hold on
plot(varying_l, bn3)
xlabel("l values")
ylabel("a(n), b(n)")
legend("a(n)","b(n)")
%Finished with the (n,an) (n,bn)


%Now I will also be doing the (k,ak) (k,bk) for the initial parameters l,e, for all three functions
figure("Name", "(k,ak), (k,bk) for e=0.001, l=0.01, f1")
plot(a_vector1);
hold on
plot(b_vector1)
xlabel("k value")
ylabel("a(k), b(k)")
legend("a(k)","b(k)")

figure("Name", "(k,ak), (k,bk) for e=0.001, l=0.01, f2")
plot(a_vector2);
hold on
plot(b_vector2)
xlabel("k value")
ylabel("a(k), b(k)")
legend("a(k)","b(k)")

figure("Name", "(k,ak), (k,bk) for e=0.001, l=0.01, f3")
plot(a_vector3);
hold on
plot(b_vector3)
xlabel("k value")
ylabel("a(k), b(k)")
legend("a(k)","b(k)")
