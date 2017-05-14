public class CA{
    
	// [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] @=> int cells[];
	// [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] @=> int nextGen[];
	[0,0,0,0] @=> int cells[];
	[0,0,0,0] @=> int nextGen[];
	[4, 3, 2, 1, -1, -1, -1, -1] @=> int mask[];
    
    fun void setCellState(int position, int value)
    {
        value => cells[position];
    }
    
    fun int getCellState(int position)
    {
        return cells[position];
    }
    
    fun int getCellArrSize()
    {
        return cells.size();
    }
    
    fun void setMaskValues(int position, int value)
    {
        // in order to change rules
        // all unused positions are negative numbers
        value => mask[position];
    }
    
    fun int getNextStateOfCell(int cellState, int lCellState, int rCellState, int rule)
    {
        0 => int nextCellState;
        4 * lCellState + 2 * cellState + rCellState => int currentStateNum;
        if ( currentStateNum == rule )
        {
            1 => nextCellState;
        }
        
        else 
        {
            0 => nextCellState;
        }
        return nextCellState;
    }
    
    fun int findWraparoundValue(int outOfBoundsNeighbour)
    {
        0 => int wrappedNeighbour;
        
        if (outOfBoundsNeighbour < 0) 
        {
            cells.size() + outOfBoundsNeighbour => wrappedNeighbour; //wraps round to the end
        }
        
        else if (outOfBoundsNeighbour > cells.size() - 1) //if it is greater than the largest element number
        {
            cells.size() - outOfBoundsNeighbour => wrappedNeighbour; // wraps round to the beginning
        }
        
        else
        {
            outOfBoundsNeighbour => wrappedNeighbour;
        }
        
        return wrappedNeighbour;
    }
    
    fun void nextToCurrentGen() // moves next gen into current and wipes next gen so fresh for next step
    {
        for(0 => int i; i < cells.size(); i++)
        {
            nextGen[i] => cells[i];
            0 => nextGen[i];
        }
    }
    
    fun void calculateNextGen()
    {
        //select cell and corresponding neighbours
        //call getNextStateOfCell for each mask position
        //set cellState in nextGen array
        // increment cell position and repeat 
       0 => int cellIndex;
       0 => int lCellIndex; 
       0 => int rCellIndex;
       
       for(0 => int i; i < cells.size(); i++) //increment through each cell in current generation
       {
           findWraparoundValue(cellIndex - 1) => lCellIndex;
           findWraparoundValue(cellIndex + 1) => rCellIndex;
           
           0 => int maskIndex;
        
           while(maskIndex < mask.size() && nextGen[cellIndex] == 0) //increment through rule masks
           {
               getNextStateOfCell(cells[cellIndex], cells[lCellIndex], cells[rCellIndex], mask[maskIndex]) => nextGen[cellIndex];
               maskIndex++;
           }
           cellIndex++;
       }
       nextToCurrentGen();       
   }

   fun int convertToBase10()
   {
	   // treats the cells array as a binary number and converts to base 10
	   // that binary number is considered to be big-endian
	   
	   cells.size() => int arraySize;

	   float MSB; // most significant bit 
	   Math.pow(2, arraySize - 1) => MSB; // arraySize - 1 because starts on the 0th element
	   //needs to treat least significant bit as 0th element because 2^1 != 1

	   0 => int totalValue;
	   Std.ftoi(MSB) => int currentCellValue; // MSB will always be a whole number so can safely convert to int by truncation
	   
	   for (0 => int i; i < arraySize; i++) // for every element in cells
	   {
		   (cells[i] * (currentCellValue)) + totalValue => totalValue; // multiplies the current bit by its value then adds it to the total value of the cell
		   currentCellValue / 2 => currentCellValue; // sets the cell value in preparation for the next loop
	   }
	   
	   return totalValue;
   }
}
