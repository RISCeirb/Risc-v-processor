

void main()
{

    

    int width = 275;
    int height = 183;
    int stride = 828; // Ensure stride is correctly calculated if needed
    int padding = 3;
  
    unsigned char pixel[3];
    for (int y = 0; y < height; ++y)
    {
        for (int x = 0; x < width; ++x)
        {
            unsigned int tempGray = imagedata[3 * x + y * 3* width] * 300 + imagedata[3 * x + 1 + y * 3* width] * 580 + imagedata[3 * x + 2 + y * 3* width ] * 110;
            unsigned char gray = (tempGray) >> 10;
            imagedata[3 * x + y * 3* width]     = gray;
            imagedata[3 * x + 1 + y * 3* width] = gray;
            imagedata[3 * x + 2 + y * 3* width] = gray;
        }
    }
}