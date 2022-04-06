int source[] = {3, 1, 4, 1, 5, 9, 0}; // register: s1
int dest[10]; // register: s2

int fun(int x) {
    return -x * (x + 1);
}

int main() {
    int k; // register: t0
    int sum = 0; // register: s0
    // loop:
    for (k = 0; source[k] != 0; k++) {
        // pointer: use a temp t1 to get offset, then get the offset+base,
        // finally load the address's value
        dest[k] = fun(source[k]);
        sum += dest[k];
    }
    return sum;
}