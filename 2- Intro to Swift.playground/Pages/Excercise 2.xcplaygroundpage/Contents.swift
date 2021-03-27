//Meth
//Let's say you have 10 MacBooks, and 10 iPads
var numMacBooks = 10
var numIPads = 10

//One MacBook died :(
numMacBooks = numMacBooks - 1

//iPads Reproduced, somehow
numIPads = numIPads * 2

//Total Equipment now
var total = numIPads + numMacBooks

//Someone eats an Ipad
numIPads -= 1

//Total equipment now? Recalculate it!
total = numIPads + numMacBooks
