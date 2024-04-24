# AsynchronousFIFO
FIFO are often used to safely pass data from one clock domain to another asynchronous clock domain. </b>
An asynchronous FIFO refers to FIFO design where data values are written to a FIFO buffer from one clock domain and the data value are read from the same FIFO buffer from another clock domain, where two clock domains are asynchronous to each other.</b>
The write pointer always points to the next word to be written.</b>
As soon as the first data is written to the FIFO, the write pointer increments, the empty flag is cleared. The read pointer always points to the current FIFO word to be read. </b>
The FIFO is empty when the read and write pointers are both equal. </b>
