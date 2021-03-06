// PHY 411-506 Computational Physics II Spring 2003
// swendsen-wang.cpp

// Swendsen-Wang cluster algorithm for the 2-D Ising Model

#include <cmath>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <list>                 // to save values for autocorrelations
#include <time.h>

using namespace std;

double J = 1;                   // ferromagnetic coupling
int Lx, Ly;                     // number of spins in x and y
int N;                          // number of spins
int **s;                        // the spins
double T;                       // temperature
double H = 0;                   // magnetic field
int steps = 0;                  // steps so far

double unif() {
    return (double) rand() / (double) RAND_MAX ;
} // end r2()

void initialize (int init_state) {
    s = new int* [Lx];
    for (int i = 0; i < Lx; i++)
        s[i] = new int [Ly];
    for (int i = 0; i < Lx; i++) {
        for (int j = 0; j < Ly; j++) {
            //double rnd = unif();
            //s[i][j] = init_state < 0.5 ? 1 : 0;
            s[i][j] = init_state;
        }
    }
    steps = 0;
} // end initialize()


void initializeRand () {
    s = new int* [Lx];
    for (int i = 0; i < Lx; i++)
        s[i] = new int [Ly];
    for (int i = 0; i < Lx; i++) {
        for (int j = 0; j < Ly; j++) {
            double rnd = unif();
            s[i][j] = rnd < 0.5 ? 1 : 0;
            //s[i][j] = init_state;
        }
    }
    steps = 0;
} // end initialize()


bool     **iBondFrozen, **jBondFrozen; // bond lattice - two bonds per spin
double   freezeProbability;            // 1 - e^(-2/T)
int      **cluster;                    // cluster labels for spins
int      *labelLabel;                  // to determine proper labels
bool     *sNewChosen;                  // has the new spin value been chosen?
int      *sNew;                        // random new spin values in each cluster

void initializeClusterVariables() {

    // allocate 2-D arrays for bonds in x and y directions    
    iBondFrozen = new bool* [Lx];
    jBondFrozen = new bool* [Lx];
    for (int i = 0; i < Lx; i++) {
        iBondFrozen[i] = new bool [Ly];
        jBondFrozen[i] = new bool [Ly];
    }

    // compute the bond freezing probability
    freezeProbability = 1 - exp(-2*J/T);

    // allocate 2-D array for spin cluster labels
    cluster = new int* [Lx];
    for (int i = 0; i < Lx; i++)
        cluster[i] = new int [Ly];

    // allocate arrays of size = number of spins for
    labelLabel = new int [N];        // proper label pointers
    sNewChosen = new bool [N];       // setting new cluster spin values
    sNew       = new int [N];        // new cluster spin values
}

// declare functions to implement Swendsen-Wang algorithm
void freezeOrMeltBonds();
int  properLabel(int label);
void labelClusters();
void flipClusterSpins();

void oneMonteCarloStep() {
    // first construct a bond lattice with frozen bonds
    freezeOrMeltBonds();
    // use the Hoshen-Kopelman algorithm to identify and label clusters
    labelClusters();
    // re-set cluster spins randomly up or down
    flipClusterSpins();
    ++steps;
}

void freezeOrMeltBonds() {

    // visit all the spins in the lattice
    for (int i = 0; i < Lx; i++) {
        for (int j = 0; j < Ly; j++) {

            // freeze or melt the two bonds connected to this spin
            // using a criterion which depends on the Boltzmann factor
            iBondFrozen[i][j] = jBondFrozen[i][j] = false;

            // bond in the i direction
            int iNext = i == Lx-1 ? 0 : i+1;
            if (s[i][j] == s[iNext][j] && unif() < freezeProbability)
                iBondFrozen[i][j] = true;

            // bond in the j direction
            int jNext = j == Ly-1 ? 0 : j+1;
            if (s[i][j] == s[i][jNext] && unif() < freezeProbability)
                jBondFrozen[i][j] = true;
        }
    }
}

int properLabel(int label) {
    while (labelLabel[label] != label)
        label = labelLabel[label];
    return label;
}

void labelClusters() {

    int label = 0;

    // visit all lattice sites
    for (int i = 0; i < Lx; i++) {
        for (int j = 0; j < Ly; j++) {

            // find previously visited sites connected to i,j by frozen bonds
            int bonds = 0;
            int iBond[4], jBond[4];

            // check bond to i-1,j
            if (i > 0 && iBondFrozen[i - 1][j]) {
                iBond[bonds] = i - 1;
                jBond[bonds++] = j;
            }

            // apply periodic conditions at the boundary:
            // if i,j is the last site, check bond to i+1,j
            if (i == Lx - 1 && iBondFrozen[i][j]) {
                iBond[bonds] = 0;
                jBond[bonds++] = j;
            }

            // check bond to i,j-1
            if (j > 0 && jBondFrozen[i][j - 1]) {
                iBond[bonds] = i;
                jBond[bonds++] = j - 1;
            }

            // periodic boundary conditions at the last site
            if (j == Ly - 1 && jBondFrozen[i][j]) {
                iBond[bonds] = i;
                jBond[bonds++] = 0;
            }

            // check number of bonds to previously visited sites
            if (bonds == 0) { // need to start a new cluster
                cluster[i][j] = label;
                labelLabel[label] = label;
                ++label;
            } else {        // re-label bonded spins with smallest proper label
                int minLabel = label;
                for (int b = 0; b < bonds; b++) {
                    int pLabel = properLabel(cluster[iBond[b]][jBond[b]]);
                    if (minLabel > pLabel)
                        minLabel = pLabel;
                }

                // set current site label to smallest proper label
                cluster[i][j] = minLabel;

                // re-set the proper label links on the previous labels
                for (int b = 0; b < bonds; b++) {
                    int pLabel = cluster[iBond[b]][jBond[b]];
                    labelLabel[pLabel] = minLabel;

                    // re-set label on connected sites
                    cluster[iBond[b]][jBond[b]] = minLabel;
                }
            }
        } // end inner for loop
    } // end outer for loop
}

int num_flips = 0;

void flipClusterSpins() {

    for (int i = 0; i < Lx; i++)
    for (int j = 0; j < Ly; j++) {

        // random new cluster spins values have not been set
        int n = i * Lx + j;
        sNewChosen[n] = false;

        // replace all labels by their proper values
        cluster[i][j] = properLabel(cluster[i][j]);
    }    

    int flips = 0;    // to count number of spins that are flipped
    for (int i = 0; i < Lx; i++)
    for (int j = 0; j < Ly; j++) {

        // find the now proper label of the cluster
        int label = cluster[i][j];

        // choose a random new spin value for cluster
        // only if this has not already been done
        if (!sNewChosen[label]) {    
            sNew[label] = unif() < 0.5 ? 1 : 0;
            sNewChosen[label] = true;
        }

        // re-set the spin value and count number of flips
        if (s[i][j] != sNew[label]) {
            s[i][j]  = sNew[label];
            ++flips;
        }
    }
    num_flips = flips;
}

double eSum;                // accumulator for energy per spin
double eSqdSum;             // accumulator for square of energy per spin
int nSum;                   // number of terms in sum

void initializeObservables() {
    eSum = eSqdSum = 0;     // zero energy accumulators
    nSum = 0;               // no terms so far
}


int getNeighborSpins(int r, int c) {
    //int *energy = malloc(4); // up, down, left, right
    int energy = 0;
    int up, down, left, right = 0;

    int current_state = s[r][c];

    // update row
    if (r == 0) {
        up    = s[Lx-1][c];
        down  = s[r+1][c];
    } else if (r == Lx-1) {
        up    = s[r-1][c];
        down  = s[0][c];
    } else {
        up    = s[r-1][c];
        down  = s[r+1][c];
    }

    // update columm
    if (c == 0) {
        left  = s[r][Lx-1];
        right = s[r][c+1]; 
    } else if (c == Lx-1) {
        left  = s[r][c-1];
        right = s[r][0];
    } else {
        left  = s[r][c-1];
        right = s[r][c+1];
    }

    energy = up + down + left + right;
    
    if (current_state == 0) {
        energy = 4 - energy;
    }
    return energy;
} // end getNeighborSpins()



void measureObservables() {
    int sSum = 0, ssSum = 0;
    for (int i = 0; i < Lx; i++)
    for (int j = 0; j < Ly; j++) {
        sSum += s[i][j];
        int iNext = i == Lx-1 ? 0 : i+1;
        int jNext = j == Ly-1 ? 0 : j+1;
        ssSum += s[i][j]*(s[iNext][j] + s[i][jNext]);
    }
    //cout << "sSum = " << ssSum << ", H = " << H << " -> " << H * sSum << endl;
    //double e = -(1.0 * ssSum)/N;
    double e = 1.0 * ssSum / (2*N);
    eSum += e;
    eSqdSum += e * e;
    ++nSum;
}

double suff_stat;           // suff. stat. used to measure convergence

void computeSS() {

    // iterate through s
    double ss = 0;
    double h;
    for (int i = 0; i < Lx; i++) {
        for (int j = 0; j < Ly; j++) {
            h = getNeighborSpins(i, j); // sum of 'like' components
            ss += h;
        }
    }
    suff_stat = ss / (2 * N); // normalized by # of edges
}

double eAve;                // average energy per spin
double eError;              // Monte Carlo error estimate

void computeAverages() {
    eAve = eSum / nSum;
    eError = eSqdSum / nSum;
    eError = sqrt(eError - eAve*eAve);
    eError /= sqrt(double(nSum));
}

int main() {

    srand(time(NULL));
    double beta;
    int    MCSteps = 50;


    beta = 1.45;
    T    = 1 / beta;
    Lx   = 256;
    Ly   = Lx;
    N    = Lx * Ly;

    /* start with thermalization steps

    int thermSteps = MCSteps / 5;
    cout << " Performing " << thermSteps 
         << " thermalization steps ..." << flush << endl;
    for (int i = 0; i < thermSteps; i++){
        oneMonteCarloStep();
        computeSS();
    }
    cout << " done\n Performing production steps ..." << flush << endl;

    initializeObservables();
    for (int i = 0; i < MCSteps; i++) {
        oneMonteCarloStep();
        computeSS();
        cout << "iter " << i+1 << " -- energy: " << suff_stat << endl;
    }

    */

    double eps = 0.01;
    double avgMC1[MCSteps];
    double avgMC2[MCSteps];
    double delta[MCSteps];

    initialize(0);
    initializeClusterVariables();
    initializeObservables();
    cout << "MC 1 H(X) Values: " << endl;
    for (int i = 0; i < MCSteps; i++) {
        oneMonteCarloStep();
        measureObservables();
        computeAverages();
        cout << eAve << "-- num flips = " << num_flips << endl;
        avgMC1[i] = eAve;
    }
    
    initializeRand();
    initializeClusterVariables();
    initializeObservables();
    cout << "MC 2 H(X) Values: " << endl;
    for (int i = 0; i < MCSteps; i++) {
        oneMonteCarloStep();
        measureObservables();
        computeAverages();
        cout << eAve << "-- num flips = " << num_flips << endl;
        avgMC2[i] = eAve;
    }


    double diff = 0;
    for (int i = 0; i < MCSteps; i++) {
        diff = avgMC1[i] - avgMC2[i];
        delta[i] = diff;
        if (fabs(diff) < eps) {
            cout << "iter: " << i;
            cout << " -- Convergencence! (" << avgMC1[i] << ", " <<
                avgMC2[i] << ")" << endl;
            break;
        }
    }

    
}