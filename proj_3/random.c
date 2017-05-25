#include <stdio.h>
#include <stdlib.h>


double r2() {
    return (double)rand() / (double)RAND_MAX ;
} // end r2()


void simulateUnif() {

  int i;
  double r;
  int c1, c2, c3, c4, c5, c6, c7, c8, c9, c10;
  c1 = c2 = c3 = c4 = c5 = c6 = c7 =c8 = c9 = c10 = 0;
  for (i = 0; i < 10000; i++) {
    r = r2();
    if (r <= 0.1) {
      c1++;
    } else if ( r <= 0.2) {
      c2++;
    } else if ( r <= 0.3) {
      c3++;
    } else if ( r <= 0.4) {
      c4++;
    } else if ( r <= 0.5) {
      c5++;
    } else if ( r <= 0.6) {
      c6++;
    } else if ( r <= 0.7) {
      c7++;
    } else if ( r <= 0.8) {
      c8++;
    } else if ( r <= 0.9) {
      c9++;
    } else if ( r <= 1.0) {
      c10++;
    }
  }

  printf("c1 =  %d\nc2 =  %d\nc3 =  %d\nc4 =  %d\nc5 =  %d\n",
          c1, c2, c3, c4, c5);
  printf("c6 =  %d\nc7 =  %d\nc8 =  %d\nc9 =  %d\nc10 =  %d\n",
          c6, c7, c8, c9, c10);

}



int main (void)
{
  int n = 10;
  int* chain = malloc(n * sizeof(int)); 
  int* tmp;
  int  i;

  //if (chain == nullptr) {
  //  print("failed to allocate memory\n");
  //}

  printf("length of chain = %d\n", (int) sizeof(*chain));

  for (i = 0; i < 20; i++) {
    if (i == n) {
      printf("i = %d\n", i);
      // reallocate memory
      tmp = realloc(chain, 2 * n * sizeof(int));
      if (!tmp) {
        printf("Could not resize data\n");
      } else {
        chain = tmp;
        n = 20;
      }

    }
    chain[i] = 100;
  }


  for (i = 0; i < 25; i++) {
    printf("i = %d -- %d\n", i, chain[i]);
  }
  

  return 0;
}