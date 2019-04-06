%Steps
%Generate sequence of white noise images
%Simulate spiking responses for them (through the model cell we already
%have?
%Scale so that average spike count per image is 0.2spikes
%Average over all images with at least 1 count
%Compare to the RF of the model neuron

%Oh so basically the point is to ask how well a reverse correlated image
%matches the actual RF. The match contrary to what I thought isn't obvious.
%Just because I infer backward, "This is the RF given the stimuli the
%cell's been most responsive to", doesn't mean that it is the RF. 
%P(this is the RF | spike always accompanied by this stimuli) = ?
%Does P(some group of stimuli | spike) being high mean that 
%avg(these stimuli) is the RF? 
%In other words, does P(some group of stimuli | spike) being high
%mean P(spike | avg. of these stimuli) is high?
%If we call the "some group of stimuli" together a kind of "ideal stimulus"
%then we can ask, "Does P(ideal stimulus | spike) being high mean
%P(spike | ideal stimulus) is high? Call this "ideal" or "average" A.
%Call a spike event S.
%This brings us to the relationship between P(A|S) and P(S|A).
%An "average" or "ideal" is the cell's RF if and only if P(A|S) and P(S|A)
%are both high.

x0=-5.0;
y0=-5.0;
x=x0;
y=y0;
ds=0.2;
s1=1;
s2=2;
k=25/14;
phi=pi/2;


XDEGREE(1)=0;
YDEGREE(1)=0;
XPIXEL(1)=0;
YPIXEL(1)=0;
RFA(1)=0;
LAMBDA=0;
ITER_series(1)=0;
LAMBDA_series(1)=0;
itermax=100;
VALUE_series=zeros(itermax,50,50);
LAMBDA_series=zeros([1 itermax]);

%Main loop
for iter=1:itermax
    LAMBDA=0;
    LAMBDA2=0;
    for i=1:50 
        for j=1:50
            x=x0+(i*ds);
            y=y0+(j*ds);
            RF=(1/(2*pi*s1*s2))*exp(-((x^2)/(2*(s1^2)))-((y^2)/(2*(s2^2))))*cosd((k*x)-90);
            RF2=(1/(2*pi*s1*s2))*exp(-((x^2)/(2*(s1^2)))-((y^2)/(2*(s2^2))))*cosd((k*x));
            I=poissrnd(200); %Image
            L=I*RF;            %Output of the linear part
            L2=I*RF2;
            VALUE(j,i)=I;
            LAMBDA=LAMBDA+L; %Linear summation
            LAMBDA2=LAMBDA2+L2;
            
            XDEGREE(i)=x;
            YDEGREE(j)=y;
            
            if(iter==1)
                RFA(j,i)=RF;
            end
        end
    end
    
    LAMBDA_series(iter)=FWS(LAMBDA)+FWS(LAMBDA2); %Half-wave squaring
    VALUE_series(iter,:,:)=VALUE; 
    disp(iter); %To keep track while running
end

for test=1:length(LAMBDA_series)
    disp(LAMBDA_series(test));
    disp('dividing');
    LAMBDA_series(test)=LAMBDA_series(test)/100000000;
    disp(LAMBDA_series(test));
end

%Remove spike counts less than 1 and corresponding white noise images
[t, v] = trim(LAMBDA_series, VALUE_series);

%Taking average of the white noise images that elicited high spike counts
RF_reverse=mean(v,1);
RF_reverse_fin=squeeze(RF_reverse); %Just to remove the singleton dimension left over from averaging


%Plot it
pcolor(XDEGREE,YDEGREE,RF_reverse_fin)
hold on
xlabel('x (degrees)');
ylabel('y (degrees)');
    

%Function to remove low spike counts and the associated images
function [trimmed, trimmed_value] = trim(series, series2)
    trimmed_index=1;
    trimmed(trimmed_index)=0;
    for index=1:length(series)
        disp('trimming');
        if series(index)>=1 %if spike count per image is at least one
            trimmed(trimmed_index)=series(index);
            trimmed_value(trimmed_index,:,:)=series2(index,:,:);
            trimmed_index=trimmed_index+1;
        end
    end
end

%Full-wave squaring function. Basically just squares.
function [outp] = FWS(inp)
        outp=inp^2;
end