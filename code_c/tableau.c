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

int* convert_image_to_int_array(const char* filename, int* width, int* height) {
    FILE* infile = fopen(filename, "rb");
    if (infile == NULL) {
        perror("Erreur d'ouverture du fichier d'entrée");
        return NULL;
    }

    BITMAPFILEHEADER bfHeader;
    BITMAPINFOHEADER biHeader;

    // Lire les en-têtes BMP
    if (fread(&bfHeader, sizeof(BITMAPFILEHEADER), 1, infile) != 1 ||
        fread(&biHeader, sizeof(BITMAPINFOHEADER), 1, infile) != 1) {
        perror("Erreur de lecture des en-têtes BMP");
        fclose(infile);
        return NULL;
    }

    if (bfHeader.bfType != 0x4D42) {
        fprintf(stderr, "Le fichier n'est pas un fichier BMP valide.\n");
        fclose(infile);
        return NULL;
    }


    *width = biHeader.biWidth;
    *height = biHeader.biHeight;

    // Calculer la taille de la ligne et de l'image
    int row_size = ((biHeader.biWidth + 3) / 4) * 4;
    int image_size = row_size * biHeader.biHeight;

    // Allouer un tampon pour les données de l'image
    uint8_t* pixel_data = malloc(image_size);
    if (pixel_data == NULL) {
        perror("Erreur d'allocation de mémoire pour les données d'image");
        fclose(infile);
        return NULL;
    }

    fseek(infile, bfHeader.bfOffBits, SEEK_SET);
    if (fread(pixel_data, image_size, 1, infile) != 1) {
        perror("Erreur de lecture des données d'image");
        free(pixel_data);
        fclose(infile);
        return NULL;
    }

    fclose(infile);

    // Allouer un tableau d'entiers pour stocker les valeurs des pixels
    int* int_array = malloc(*width * *height * sizeof(int));
    if (int_array == NULL) {
        perror("Erreur d'allocation de mémoire pour le tableau d'entiers");
        free(pixel_data);
        return NULL;
    }

    // Convertir les données des pixels en entiers
    for (int y = 0; y < *height; y++) {
        for (int x = 0; x < *width; x++) {
            // BMP stocke les pixels de bas en haut
            int pixel_index = (biHeader.biHeight - 1 - y) * row_size + x;
            int_array[y * *width + x] = pixel_data[pixel_index];
        }
    }

    free(pixel_data);
    return int_array;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input BMP>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int width, height;
    int* int_array = convert_image_to_int_array(argv[1], &width, &height);

    if (int_array == NULL) {
        return EXIT_FAILURE;
    }

    // Afficher les premiers éléments du tableau pour vérification
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            printf("%3d ", int_array[y * width + x]);
        }
        printf("\n");
    }

    free(int_array);
    return EXIT_SUCCESS;
}
