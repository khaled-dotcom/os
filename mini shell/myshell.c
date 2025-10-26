#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAX_LINE 1024   // Maximum length of input
#define MAX_ARGS 64     // Maximum number of words in a command

int main() {
    char line[MAX_LINE];   // Store input command
    char *args[MAX_ARGS];  // Store command arguments

    while (1) {
        // 1️⃣ Show prompt
        printf("myshell> ");

        // 2️⃣ Read input from user
        if (fgets(line, MAX_LINE, stdin) == NULL) {
            printf("\n");
            break; // Exit on Ctrl+D
        }

        // Remove newline character
        line[strcspn(line, "\n")] = 0;

        // 3️⃣ Split input into words
        int i = 0;
        args[i] = strtok(line, " "); // First word
        while (args[i] != NULL && i < MAX_ARGS - 1) {
            i++;
            args[i] = strtok(NULL, " "); // Next words
        }

        // If nothing was typed, show prompt again
        if (i == 0) continue;

        // 4️⃣ Built-in command: exit
        if (strcmp(args[0], "exit") == 0) break;

        // 5️⃣ Built-in command: cd
        if (strcmp(args[0], "cd") == 0) {
            if (args[1] == NULL) {
                printf("cd: missing directory\n");
            } else {
                if (chdir(args[1]) != 0) {
                    perror("cd failed");
                }
            }
            continue;
        }

        // 6️⃣ Run other commands
        pid_t pid = fork(); // Create a child process
        if (pid < 0) {
            perror("fork failed");
            exit(1);
        }

        if (pid == 0) {
            // Child process: execute command
            if (execvp(args[0], args) == -1) {
                perror("execvp failed");
            }
            exit(1);
        } else {
            // Parent process: wait for child to finish
            wait(NULL);
        }
    }

    return 0;
}
