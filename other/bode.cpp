#include <cmath>
#include <complex>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

template <typename T>
void parse_input(std::vector<T> &A, const std::string line) {
        std::stringstream ss(line);
        T tmp;
        for (; ss >> tmp;) {
                A.push_back(tmp);
        }
}

template <typename T>
std::complex<T> s2jw(const std::vector<T> A, const std::complex<T> jw) {
        std::complex<T> N{0, 0};
        for (const auto &n : A) {
                N = N * jw + n;
        }
        return N;
}

int main() {
        std::string line;
        std::vector<double> num, den;

        std::cout << "Input numerator (b_n b_n-1 ... b0): ";
        getline(std::cin, line);
        parse_input(num, line);

        std::cout << "Input denominator (a_n a_n-1 ... a0): ";
        getline(std::cin, line);
        parse_input(den, line);

        std::vector<std::pair<double, double>> G_mag;
        std::complex<double> N, M;
        for (std::complex<double> jw{0, 0.01}; jw.imag() < 100; jw += std::complex<double>{0, 0.1}) {
                N = s2jw(num, jw);
                M = s2jw(den, jw);
                G_mag.push_back({jw.imag(), 20 * log10(abs(N / M))});
        }
        
        for (auto mag: G_mag) 
                std::cout<< mag.first << " " << mag.second << std::endl;
        return 0;
}