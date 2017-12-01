% p(1) = alpha  = bias / mean / threshold / PSE
% p(2) = beta   = slope
% p(3) = gamma  = guess rate
% p(4) = lambda = lapse rate

function output = psychometricFit(x,y,subjNum,condition,save)
    %hold the previous figure
    figure;

    %psyFit = @(p,a) 0.5*(erfc((a-p(1))/(p(2)*sqrt(2))));
    %   y  =     gamma+(1-gamma-lambda)*0.5*erfc(-beta.*(x-alpha)./sqrt(2));
    psyFit = @(p,a) p(3)+(1-p(3)-p(4))*0.5*(erfc((-p(2)).*(a-p(1))./sqrt(2)));
    
    %Get an estimate of the parameters from the function and guess valuese
    pEst = nlinfit(x,y,psyFit,[0.5, 1, 0, 1]);
    %Createdetailed points of x for smooth sigmoid curve
    newX = linspace(x(1),x(end),40);
    %Make an long array of estimated y values based on the parameters above
    y_pred = psyFit(pEst,newX);
    
    %Plot the original values with large black dots
    plot(x,y,'k.','MarkerSize',20,'Color','k');
    %label and title the plot
    %ylabel('Proportion Chosen Saturation Periphery > Center');
    %xlabel('Saturation in Periphery');
    %title(['Subject ' num2str(subjNum) ', Condition ' num2str(condition)]);
    xlim([0.2 0.8]);
    ylim([0 1]);
    
    %Change the tick label size
    xlabel('','FontSize',20);
    xt = get(gca,'XTick');
    set(gca, 'FontSize',16);
    
    
    %Hold so that another plot can go over the same figure
    hold on;
    %Plot the predicted values based on the psychometric function
    plot(newX,y_pred,'-','LineWidth',2,'Color',[0.5 0.5 0.5]);
    %Add the legend
    %legendObject = legend('Data','Model Fit','Location','northwest');
    %legendObject.FontSize = 18;
    
    %Get the x when y = 0.5 (the PSE)
    PSE = inverseCumulativeGaussian(pEst,0.5);
    %Draw the lines for PSE
    hold on;
    plot([0.2,PSE,PSE,PSE],[0.5,0.5,0,0.5],'--','LineWidth',1,'Color','k');
    %legendObject = legend('PSE','northwest');
    %legendObject.FontSize = 18;
    
        
    %Get the y when x = 0.5 (the % they picked one over the other when it was equal)
    yWhenEqual = y(3);
    %Draw the lines to the point
    hold on;
    plot([0.2,0.5,0.5,0.5],[yWhenEqual,yWhenEqual,0,yWhenEqual],':','LineWidth',1,'Color','k');

    
    %Save the figure
    if(save == 1)
        fileName = ['Expt2_Subject' num2str(subjNum) '_Condition' num2str(condition) '.png'];
        saveas(gcf,fileName);
    end
    
    %Output the bias and slope (the parameters)
    output = pEst;
end
