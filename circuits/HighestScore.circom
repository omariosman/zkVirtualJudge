pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";

template GetHighestScore (participants_num) {
    signal input scores[participants_num];
    
    signal input scores_val_secret[participants_num][2]; //associating each score to a 2d array contains the secret and the score
