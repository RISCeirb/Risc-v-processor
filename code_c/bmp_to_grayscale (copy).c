#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// Structures pour lire les entêtes BMP
#pragma pack(push, 1)
typedef struct {
    uint16_t bfType;
    uint32_t bfSize;
    uint16_t bfReserved1;
    uint16_t bfReserved2;
    uint32_t bfOffBits;
} BITMAPFILEHEADER;

typedef struct {
    uint32_t biSize;
    int32_t  biWidth;
    int32_t  biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    int32_t  biXPixPerMeter;
    int32_t  biYPixPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
} BITMAPINFOHEADER;
#pragma pack(pop)

void convert_to_grayscale(uint8_t *pixel_data, int width, int height) {
    int row_size = ((width * 3 + 3) / 4) * 4; // Chaque ligne doit être un multiple de 4 octets
    uint8_t *row = malloc(row_size);
    if (row == NULL) {
        fprintf(stderr, "Erreur d'allocation de mémoire.\n");
        exit(EXIT_FAILURE);
    }

    for (int y = 0; y < height; y++) {
        uint8_t *row_start = pixel_data + (height - 1 - y) * row_size; // BMP commence de bas en haut
        memcpy(row, row_start, row_size);
        for (int x = 0; x < width; x++) {
            uint8_t *pixel = row + x * 3;
            uint8_t gray = (uint8_t)(0.299 * pixel[2] + 0.587 * pixel[1] + 0.114 * pixel[0]); // Conversion en niveaux de gris
            pixel[0] = pixel[1] = pixel[2] = gray; // Mettre R, G et B au même niveau
        }
        memcpy(row_start, row, row_size); // Écrire les lignes modifiées dans le tampon original
    }

    free(row);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input BMP> <output BMP>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *input_file = argv[1];
    const char *output_file = argv[2];

    FILE *infile = fopen(input_file, "rb");
    if (infile == NULL) {
        perror("Erreur d'ouverture du fichier d'entrée");
        return EXIT_FAILURE;
    }

    FILE *outfile = fopen(output_file, "wb");
    if (outfile == NULL) {
        perror("Erreur d'ouverture du fichier de sortie");
        fclose(infile);
        return EXIT_FAILURE;
    }

    BITMAPFILEHEADER bfHeader;
    BITMAPINFOHEADER biHeader;

    fread(&bfHeader, sizeof(BITMAPFILEHEADER), 1, infile);
    fread(&biHeader, sizeof(BITMAPINFOHEADER), 1, infile);

    if (bfHeader.bfType != 0x4D42) {
        fprintf(stderr, "Le fichier n'est pas un fichier BMP valide.\n");
        fclose(infile);
        fclose(outfile);
        return EXIT_FAILURE;
    }

    if (biHeader.biBitCount != 24) {
        fprintf(stderr, "Le fichier BMP doit être en 24 bits par pixel.\n");
        fclose(infile);
        fclose(outfile);
        return EXIT_FAILURE;
    }

    int width = biHeader.biWidth;
    int height = biHeader.biHeight;
    int row_size = ((width * 3 + 3) / 4) * 4;
    int image_size = row_size * height;

    uint8_t *pixel_data = malloc(image_size);
    if (pixel_data == NULL) {
        fprintf(stderr, "Erreur d'allocation de mémoire pour les données d'image.\n");
        fclose(infile);
        fclose(outfile);
        return EXIT_FAILURE;
    }

    fseek(infile, bfHeader.bfOffBits, SEEK_SET);
    fread(pixel_data, image_size, 1, infile);

    convert_to_grayscale(pixel_data, width, height);

    fseek(outfile, 0, SEEK_SET);
    fwrite(&bfHeader, sizeof(BITMAPFILEHEADER), 1, outfile);
    fwrite(&biHeader, sizeof(BITMAPINFOHEADER), 1, outfile);
    fwrite(pixel_data, image_size, 1, outfile);

    free(pixel_data);
    fclose(infile);
    fclose(outfile);

    return EXIT_SUCCESS;
}
