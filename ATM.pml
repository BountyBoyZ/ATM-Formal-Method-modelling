mtype = { create_accounts, no_card_ops, card_ops, buy_credit, pay_bill, transfer, withdraw, deposit, enter_number, check_balance, done }
mtype operation;

typedef Account {
    int acc_num;
    byte name[10];
    int balance;
    byte pin1[4];
    byte pin2[4];
}

Account accounts[3];
byte entered_pin1[4];
byte entered_pin2[4];
int entered_acc;
int trials;
int phone_num;
int amount;
int bill_id;

init {
    atomic {
        printf("Creating 3 bank accounts...\n");
        // Account 1
        accounts[0].acc_num = 1;
        accounts[0].name = "Ali";
        accounts[0].balance = 1000;
        accounts[0].pin1 = "1234";
        accounts[0].pin2 = "5678";

        // Account 2
        accounts[1].acc_num = 2;
        accounts[1].name = "Reza";
        accounts[1].balance = 2000;
        accounts[1].pin1 = "2345";
        accounts[1].pin2 = "6789";

        // Account 3
        accounts[2].acc_num = 3;
        accounts[2].name = "Sara";
        accounts[2].balance = 3000;
        accounts[2].pin1 = "3456";
        accounts[2].pin2 = "7890";

        operation = enter_number;
    }
}

proctype atm() {
    do
    :: operation == enter_number -> {
            printf("ATM: Enter operation type (no_card_ops/card_ops):\n");
            // simulate input
            operation = no_card_ops;
        }
    :: operation == no_card_ops -> {
            printf("No card operations selected. Choose (buy_credit/pay_bill):\n");
            // simulate input
            operation = buy_credit;
        }
    :: operation == buy_credit -> {
            printf("Buy credit selected. Enter amount (10/50/100):\n");
            // simulate input
            amount = 50;
            printf("Enter phone number:\n");
            // simulate input
            phone_num = 123456789;
            printf("Enter account number:\n");
            // simulate input
            entered_acc = 1;
            printf("Enter second PIN:\n");
            // simulate input
            entered_pin2 = "5678";

            if
            :: (accounts[entered_acc-1].pin2 == entered_pin2) -> {
                    accounts[entered_acc-1].balance -= amount;
                    printf("Credit purchased. Remaining balance: %d\n", accounts[entered_acc-1].balance);
                    operation = done;
                }
            :: else -> {
                    printf("Incorrect second PIN. Transaction failed.\n");
                    operation = done;
                }
            fi;
        }
    :: operation == pay_bill -> {
            printf("Pay bill selected. Enter bill ID:\n");
            // simulate input
            bill_id = 987654321;
            printf("Enter account number:\n");
            // simulate input
            entered_acc = 2;

            if
            :: (bill_id % 2 == 0) -> {
                    accounts[entered_acc-1].balance -= 100;
                    printf("Bill paid. Amount: 100. Remaining balance: %d\n", accounts[entered_acc-1].balance);
                    operation = done;
                }
            :: else -> {
                    accounts[entered_acc-1].balance -= 50;
                    printf("Bill paid. Amount: 50. Remaining balance: %d\n", accounts[entered_acc-1].balance);
                    operation = done;
                }
            fi;
        }
    :: operation == card_ops -> {
            printf("Card operations selected. Enter account number:\n");
            // simulate input
            entered_acc = 1;
            trials = 0;

            do
            :: (trials < 3) -> {
                    printf("Enter first PIN:\n");
                    // simulate input
                    entered_pin1 = "1234";
                    if
                    :: (accounts[entered_acc-1].pin1 == entered_pin1) -> {
                            printf("PIN correct. Choose (transfer/withdraw/deposit):\n");
                            // simulate input
                            operation = withdraw;
                            break;
                        }
                    :: else -> {
                            printf("Incorrect PIN. Try again.\n");
                            trials++;
                        }
                    fi;
                }
            :: (trials >= 3) -> {
                    printf("Too many incorrect attempts. Resetting...\n");
                    operation = enter_number;
                    break;
                }
            od;
        }
    :: operation == transfer -> {
            printf("Transfer selected. Enter target account number:\n");
            // simulate input
            int target_acc = 2;
            printf("Confirm transfer to %s (account %d). Enter amount:\n", accounts[target_acc-1].name, accounts[target_acc-1].acc_num);
            // simulate input
            amount = 100;
            accounts[entered_acc-1].balance -= amount;
            accounts[target_acc-1].balance += amount;
            printf("Transfer complete. Remaining balance: %d\n", accounts[entered_acc-1].balance);
            operation = done;
        }
    :: operation == withdraw -> {
            printf("Withdraw selected. Enter amount (10/50/100/20 or custom):\n");
            // simulate input
            amount = 50;

            if
            :: (amount <= accounts[entered_acc-1].balance) -> {
                    accounts[entered_acc-1].balance -= amount;
                    printf("Withdraw complete. Remaining balance: %d\n", accounts[entered_acc-1].balance);
                    operation = done;
                }
            :: else -> {
                    printf("Insufficient balance. Transaction failed.\n");
                    operation = done;
                }
            fi;
        }
    :: operation == deposit -> {
            printf("Deposit selected. Enter amount (10/50/100/20 or custom):\n");
            // simulate input
            amount = 100;
            accounts[entered_acc-1].balance += amount;
            printf("Deposit complete. New balance: %d\n", accounts[entered_acc-1].balance);
            operation = done;
        }
    :: operation == done -> {
            printf("Operation completed. Returning to main menu.\n");
            operation = enter_number;
        }
    od;
}