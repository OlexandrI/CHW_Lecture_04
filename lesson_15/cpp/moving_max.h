// moving_max.h
// 64 samples, sliding window of 8 signed integers
// OlexandrI.B

#ifndef MOVING_MAX_H
#define MOVING_MAX_H
#define N_SAMPLES 64
#define WINDOW 8
void moving_max(int in[N_SAMPLES], int out[N_SAMPLES]);
#endif
