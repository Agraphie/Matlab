function [T]= sacados(V, W, wmax)

%do we have only positive integer values in V?
reply = input('Do we have only positive integer values in V? Y/N/D [D]: ', 's');
if reply ~= 'Y' | 'y'
	%set a counter to avoid annoying questions
	j=0;
	for i=1:size(V,2)
		if V(i) < 0
			if j == 3
				reply = input('A lot of negative values found, fix all of them? Y/N [Y]: ', 's');
				if isempty(reply) | reply=='Y'
    					V(i)=V(i)*-1;
    					j=j+1;
    					continue;
				elseif reply=='N'
					j=0;
					continue
				else 
					V(i)=V(i)*-1;
    					j=j+1;
    					continue;
	    			end
			elseif j > 3
				V(i)=V(i)*-1;
				continue
			elseif j < 3	
				reply = input('Negative value found, fix it? Y/N [Y]: ', 's');
				if isempty(reply) | reply=='Y'
  	  				V(i)=V(i)*-1;
  	  				j=j+1;
				elseif reply=='N'
					return ;		
				end
			end
		end
	end
end

%do we have only positive integer values in W?
reply = input('Do we have only positive integer values in W? Y/N/D [D]: ', 's');
if reply ~= 'Y' | 'y'
	%set a counter to avoid annoying questions
	j=0;
	for i=1:size(V,2)
		if W(i) < 0
			if j == 3
				reply = input('A lot of negative values found, fix all of them? Y/N [Y]: ', 's');
				if isempty(reply) | reply=='Y'
    					W(i)=W(i)*-1;
    					j=j+1;
    					continue;
				elseif reply=='N'
					j=0;
					continue
				else 
					W(i)=W(i)*-1;
    					j=j+1;
    					continue;
	    			end
			elseif j > 3
				V(i)=V(i)*-1;
				continue
			elseif j < 3	
				reply = input('Negative value found, fix it? Y/N [Y]: ', 's');
				if isempty(reply) | reply=='Y'
  	  				W(i)=V(i)*-1;
  	  				j=j+1;
				elseif reply=='N'
					return ;		
				end
			end
		end
	end
end

%add 0 a position 1 to make dynamic programming easier
V=[0 V];
W=[0 W];

%Initialize the value matrix with zeros
M=zeros(size(V,2),wmax);


%j goes over all rows in the value matrix 'M' and with that over all items in 'v'
for j=2:size(M,1)
	%i goes over all columns in the value matrix and with that over all avaible 
	%weights from 1 to the max given weight 'wmax'
	for i=1:size(M,2)
		%test if the current item fits in the current weight
		if W(j) <= i 
			%test if you fit the item in, if there is some space (weight) left
			if i-W(j) == 0
				%test if the value of my current item higher is, as the value of item in the row above
				if V(j) > M(j-1,i)
					%current value is higher, fit item in
					M(j,i) = V(j);
				else
					%current value is not higher, copy the value from the position above
					M(j,i) = M(j-1,i);
				end
			else
				
				%rest weight avaible, calculate the sum of the value of 
				%the item you could fit in with the rest weight and the current item
			
				m=V(j)+M(j-1, i-W(j));
				
				%test if the sum is higher than the item in the row above
				if m > M(j-1,i)
					%it is, fit it in
					M(j,i) = m;
				%it's not
				else 
					%copy value from above
					M(j,i) = M(j-1,i);
				end
			end
		else
			M(j,i)=M(j-1,i);
		end
	end
end


%now let's build our vector with all the items we keep, for that we are going backwards
%through the value matrix. We add an item to 'T' when M(j,wmax) is different from M(j-1,wmax), which means
%we didn't copy the value from the row above. Then we update our current weight wmax. 
%If wmax equals 0, our knapsack is full and we are done.

T=zeros(1,numel(V));

for j=size(M,1):-1:2
	if wmax==0
		break;
	end
	if M(j,wmax) ~= M(j-1,wmax)
		T(j) = 1;
		wmax=wmax-W(j);
	end	
end
%delete the first item (always the 0) which we added to make dynamic programming easier
T(1)=[];