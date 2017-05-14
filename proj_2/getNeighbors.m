function nbrs = getNeighbors(r, c, mc)
    energy = 0;
    
    n = size(mc,1);
    % udpate row
    if r == 1             		% top row
       UP   = mc(n, c);
       DOWN = mc(r+1, c); 
    elseif r == n       		% top row
        UP = mc(r - 1, c);
        DOWN = mc(1, c);
    else
        UP   = mc(r - 1, c);
        DOWN = mc(r + 1, c);
    end
    
    % update column
    if c == 1                	% left col
        LEFT = mc(r, n);
        RIGHT = mc(r, c + 1);
    elseif c == n          		 % right col
        LEFT = mc(r, c - 1);
        RIGHT = mc(r, 1);
    else  
        LEFT = mc(r, c - 1);
        RIGHT = mc(r, c + 1);
    end
    
    nbrs = [UP DOWN LEFT RIGHT];
end