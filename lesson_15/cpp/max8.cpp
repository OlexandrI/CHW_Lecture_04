// max8.cpp
// Maximum of eight signed samples
// OlexandrI.B

#ifdef PIPELINED
#pragma HLS pipeline II=1
#endif
int max8(int a, int b, int c, int d, int e, int f, int g, int h) {
    int m0=(a>b)?a:b;
    int m1=(c>d)?c:d;
    int m2=(e>f)?e:f;
    int m3=(g>h)?g:h;
    int m4=(m0>m1)?m0:m1;
    int m5=(m2>m3)?m2:m3;
    return (m4>m5)?m4:m5;
}
