INC_PATH = /home/eric/gsl-2.3
GSL_PATH = /home/eric/gsl-2.3
HDRS = 
OBJS = swCluster.o
LIB_PATH = /home/eric/torch/install/lib
LIB = -lpthread -lrt -ldl -lm
CFLAGS = -g -I$(GSL_PATH)

all: sw

sw: $(OBJS)
	g++ $(CFLAGS) $(OBJS) -o sw -L$(LIB_PATH) $(LIB)

swCluster.o: swCluster.c $(HDRS)
	g++ $(CFLAGS) -c swCluster.cpp -o swCluster.o

clean:
	rm -f $(OBJS) sw