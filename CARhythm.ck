0.5::second => dur quarter;
0.25 * quarter => dur eighth;

SinOsc imp => dac;
Noise imp2 => dac;

650 => imp.freq;
0 => imp.gain;
// 440 => imp2.freq;
0 => imp2.gain;

fun void stopNote(SinOsc osc, dur length)
{
	length => now;
	0.0 => osc.gain;
}

fun void stopNoise(Noise osc, dur length)
{
	length => now;
	0.0 => osc.gain;
}

fun void rhy1()
{
	CA caObject;
	[0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0] @=> int initialCells[];
	[5, 4, 2, 1, 6, -1, -1, -1] @=> int initialMasks[]; 
	
	caObject.getCellArrSize() => int cellSize;
	for (0 => int i; i < cellSize; i++)
	{
		caObject.setCellState(i, initialCells[i]);
	}

	for (0 => int i; i < 8; i++)
	{
		caObject.setMaskValues(i, initialMasks[i]);
	}

	while(true)
	{
		for(0 => int i; i < cellSize; i++)
		{
			if (caObject.getCellState(i) == 1)
			{
				0.02 => imp.gain;
				spork ~ stopNote(imp, 0.08 * quarter);
			}
			eighth => now;
		}
		caObject.calculateNextGen();
	}
}

fun void rhy2()
{
	CA caObject2;
	[1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1] @=> int initialCells[];
	[5, 4, 2, 1, -1, -1, -1, -1] @=> int initialMasks[]; 
	caObject2.getCellArrSize() => int cellSize;
	for (0 => int i; i < cellSize; i++)
	{
		caObject2.setCellState(i, initialCells[i]);
	}

	for (0 => int i; i < 8; i++)
	{
		caObject2.setMaskValues(i, initialMasks[i]);
	}

	while(true)
	{
		for(0 => int i; i < cellSize; i++)
		{
			if (caObject2.getCellState(i) == 1)
			{
				0.02 => imp2.gain;
				spork ~ stopNoise(imp2, 0.05 * quarter);
			}
			eighth => now;
		}
		caObject2.calculateNextGen();
	}
}

spork ~ rhy1();
spork ~ rhy2();

while(true)
{
	1::second => now;
}