INC_PATH = /home/eric/gsl-2.3
GSL_PATH = /home/eric/gsl-2.3
HDRS = 
OBJS = clusterSampling.o
LIB_PATH = /home/eric/torch/install/lib
LIB = -lpthread -lrt -ldl -lm
CFLAGS = -g -I$(GSL_PATH)

all: target

target: $(OBJS)
	gcc $(CFLAGS) $(OBJS) -o target -L$(LIB_PATH) $(LIB)

clusterSampling.o: clusterSampling.c $(HDRS)
	gcc $(CFLAGS) -c clusterSampling.c -o clusterSampling.o

clean:
	rm -f $(OBJS) target