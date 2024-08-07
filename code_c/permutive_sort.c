int i,j,k,c;

for(i=1;i<N;i++) {

    if ( T[i] < T[i-1] ) { // si l’élément est mal placé

        j = 0;

        while ( T[j] < T[i] ) j++; // cette boucle sort par j = la nouvelle position de l’élément
 
 c = T[i]; // ces 2 lignes servent a translater les cases en avant pour pouvoir insérer l’élément a sa nouvelle position
        for( k = i-1 ; k >= j ; k-- ) T[k+1] = T[k];
 T[j] = c; // l'insertion
    }
}
