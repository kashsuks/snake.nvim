#include <iostream>
#include <deque>
#include <cstdlib>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

using namespace std;

int width = 20, height = 10;
int x = width / 2, y = height / 2;
int fx, fy, score = 0;
deque<pair<int, int>> snake = {{y, x}};
enum Direction { STOP, LEFT, RIGHT, UP, DOWN };
Direction dir = STOP;

void draw() {
    system("clear");
    for (int i = 0; i < width + 2; i++) cout << "#";
    cout << "\n";
    for (int i = 0; i < height; i++) {
        cout << "#";
        for (int j = 0; j < width; j++) {
            bool printed = false;
            for (auto& s : snake) {
                if (s.first == i && s.second == j) {
                    cout << "O";
                    printed = true;
                    break;
                }
            }
            if (i == fy && j == fx) cout << "F";
            else if (!printed) cout << " ";
        }
        cout << "#\n";
    }
    for (int i = 0; i < width + 2; i++) cout << "#";
    cout << "\nScore: " << score << "\n";
}

int kbhit() {
    termios oldt, newt;
    int ch;
    int oldf;
    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
    ch = getchar();
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    fcntl(STDIN_FILENO, F_SETFL, oldf);
    if (ch != EOF) {
        ungetc(ch, stdin);
        return 1;
    }
    return 0;
}

void input() {
    if (kbhit()) {
        switch (getchar()) {
            case 'a': dir = LEFT; break;
            case 'd': dir = RIGHT; break;
            case 'w': dir = UP; break;
            case 's': dir = DOWN; break;
            case 'q': exit(0);
        }
    }
}

void logic() {
    int newY = snake.front().first;
    int newX = snake.front().second;
    switch (dir) {
        case LEFT:  newX--; break;
        case RIGHT: newX++; break;
        case UP:    newY--; break;
        case DOWN:  newY++; break;
        default: return;
    }
    if (newX < 0 || newX >= width || newY < 0 || newY >= height) exit(0);
    for (auto& s : snake)
        if (s.first == newY && s.second == newX) exit(0);

    snake.push_front({newY, newX});
    if (newY == fy && newX == fx) {
        score++;
        fx = rand() % width;
        fy = rand() % height;
    } else {
        snake.pop_back();
    }
}

void setup() {
    srand(time(0));
    fx = rand() % width;
    fy = rand() % height;
}

int main() {
    setup();
    while (true) {
        draw();
        input();
        logic();
        usleep(100000);
    }
}
