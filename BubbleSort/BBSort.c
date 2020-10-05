#include <stdio.h>
#include <stdlib.h>

void BBSort(int *arr, int size) {
    for (int i = 0; i < size; ++i)
        for (int j = 0; j < size - i; ++j)
            if (arr[j] < arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }

}

int main()
{
    int arr[] = {2, 3, 7, 4, 1};
    int size = 5
    BBSort(arr, size - 1);
    for (int i = 0; i < size; ++i) {
        printf("%d\n", arr[i]);
    }
    return 0;
}