#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    FILE *fOut = fopen("output.bmp", "wb");
    /*if (!fIn || !fOut)
    {
        printf("File error.\n");
        return 0;
    }*/

    //unsigned char header[54];
    //fread(header, sizeof(unsigned char), 54, fIn);
    //fwrite(header, sizeof(unsigned char), 54, fOut);

    /*int width = *(int*)&header[18];
    int height = abs(*(int*)&header[22]);
    int stride = (width * 3 + 3) & ~3;
    int padding = stride - width * 3;*/


    int width = 275;
    int height = 183;
    int stride = 828;
    int padding = 3;

    unsigned char pixel[3];
    for (int y = 0; y < height; ++y)
    {
        for (int x = 0; x < width; ++x)
        {
            unsigned int tempGray = imagedata[3*x+y*height] * 300 + imagedata[3*x +1 + y*height] * 580 + imagedata[3*x+2+y*height] * 110;
            unsigned char gray = (tempGray) >> 10; //  shifting right by 10 bits divide by 1024
            memset(pixel, gray, sizeof(pixel));
            fwrite(&pixel, 3, 1, fOut);
            printf("Rout = %d Gout = %d Bout = %d\n", pixel[0], pixel[1], pixel[2]); // affiche les pixels de l'image
        }
    fwrite(pixel, padding, 1, fOut);
    }
    fclose(fOut);
    return 0;
}