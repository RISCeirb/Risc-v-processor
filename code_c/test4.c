#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{


    int width = 275;
    int height = 183;
    int stride = 828;
    int padding = 3;
    unsigned char pixel[3];

    FILE *fOut = fopen("output.bmp", "wb"); // Ensure the file is correctly opened

   
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            unsigned int tempGray = imagedata[3 * x + y * stride] * 300 + imagedata[3 * x + 1 + y * stride] * 580 + imagedata[3 * x + 2 + y * stride] * 110;
            unsigned char gray = (tempGray) >> 10; // Shifting right by 10 bits to divide by 1024

            memset(pixel, gray, sizeof(pixel));
            fwrite(pixel, sizeof(pixel), 1, fOut);
            printf("Rout = %d Gout = %d Bout = %d\n", pixel[0], pixel[1], pixel[2]); // Display the pixel values
        }
        unsigned char paddingBytes[3] = {0, 0, 0}; // Padding bytes (assuming padding is always 3)
        fwrite(paddingBytes, padding, 1, fOut); // Write padding bytes
    }

    fclose(fOut);
    return 0;
}
