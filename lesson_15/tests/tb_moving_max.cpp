// tb_moving_max.cpp
// Reference check and vectors for RTL simulation
// OlexandrI.B

#include <climits>
#include <cstdint>
#include <cstdio>
#include "moving_max.h"

int main() {
    static_assert(sizeof(int)==4,"32-bit int required");
    int in[64], out[64], expected[64];
    uint32_t seed=0x12345678;
    const char *names[]={"increasing","decreasing","negative","constant",
                         "expired_peak","int_limits","alternating","random"};
    FILE *vectors=std::fopen("vectors.hex","w");
    FILE *golden=std::fopen("expected.hex","w");
    if (!vectors || !golden) return 1;
    for (int test=0; test<8; test++) {
        for (int n=0; n<64; n++) {
            switch(test) {
                case 0: in[n]=n-32; break;
                case 1: in[n]=64-n; break;
                case 2: in[n]=-100+n%13; break;
                case 3: in[n]=-17; break;
                case 4: in[n]=(n==0 || n==23)?1000:-n; break;
                case 5: in[n]=(n%9==0)?INT_MAX:INT_MIN; break;
                case 6: in[n]=(n%2)?-100:100; break;
                default:
                    seed^=seed<<13; seed^=seed>>17; seed^=seed<<5;
                    in[n]=static_cast<int>(seed&0x7fffffff)-0x40000000;
            }
            out[n]=0x12345678;
        }
        moving_max(in,out);
        for (int n=0; n<64; n++) {
            expected[n]=INT_MIN;
            int first=(n<7)?0:n-7;
            for (int k=first; k<=n; k++)
                if (in[k]>expected[n]) expected[n]=in[k];
            if (out[n]!=expected[n]) {
                std::printf("FAIL %s [%d]: got %d, expected %d\n",names[test],n,out[n],expected[n]);
                std::fclose(vectors); std::fclose(golden); return 1;
            }
            std::fprintf(vectors,"%08x\n",static_cast<unsigned>(in[n]));
            std::fprintf(golden,"%08x\n",static_cast<unsigned>(expected[n]));
        }
        std::printf("PASS %s: 64 samples\n",names[test]);
    }
    std::fclose(vectors); std::fclose(golden);
    std::puts("ALL C++ TESTS PASSED: 8 vectors, 512 samples");
    return 0;
}
