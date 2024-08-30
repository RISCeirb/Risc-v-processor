#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    


    FILE *fIn = fopen("input.bmp", "rb");
    FILE *fOut = fopen("output.bmp", "wb");
 

    unsigned char header[54];

    fread(header, sizeof(unsigned char), 54, fIn);
    fwrite(header, sizeof(unsigned char), 54, fOut);

    /*int width = *(int*)&header[18];
    int height = abs(*(int*)&header[22]);
    int stride = (width * 3 + 3) & ~3;
    int padding = stride - width * 3;*/

    int width = 275;
    int height = 183;
    int stride = 828; // Ensure stride is correctly calculated if needed
    int padding = 3;
  
    unsigned char pixel[3];
    for (int y = 0; y < height; ++y)
    {
        for (int x = 0; x < width; ++x)
        {
            fread(pixel, 3, 1, fIn);
            //printf("R = %d G = %d B = %d\n", pixel[0], pixel[1], pixel[2]); // affiche les pixels de l'image
            //unsigned char gray = (pixel[0] * 300 + pixel[1] * 580 + pixel[2] * 110)/1000;
            unsigned int tempGray = imagedata[3 * x + y * 3* width] * 300 + imagedata[3 * x + 1 + y * 3* width] * 580 + imagedata[3 * x + 2 + y * 3* width ] * 110;
            unsigned char gray = (tempGray) >> 10;
            memset(pixel, gray, sizeof(pixel));
            fwrite(&pixel, 3, 1, fOut);
            //printf("Rout = %d Gout = %d Bout = %d\n", pixel[0], pixel[1], pixel[2]); // affiche les pixels de l'image
        }
        fread(pixel, padding, 1, fIn);
        fwrite(pixel, padding, 1, fOut);
    }
    fclose(fOut);
    fclose(fIn);
    return 0;
}