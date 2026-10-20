// moving_max.cpp
// Sliding maximum, each input is read once
// OlexandrI.B

#include <climits>
#include "moving_max.h"

int max8(int, int, int, int, int, int, int, int);

void moving_max(int in[N_SAMPLES], int out[N_SAMPLES]) {
    int window[WINDOW];
    for (int k=0; k<WINDOW; k++) window[k]=INT_MIN;

    for (int n=0; n<N_SAMPLES; n++) {
        // Shift old samples, then read the next one
        for (int k=WINDOW-1; k>0; k--) window[k]=window[k-1];
        window[0]=in[n];
        out[n]=max8(window[0],window[1],window[2],window[3],
                    window[4],window[5],window[6],window[7]);
    }
}
