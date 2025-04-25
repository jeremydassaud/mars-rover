export class Bowling{
    roll(gameNotation: string): number {
        // Analyser la notation et calculer le score
        return this.calculate(gameNotation);
    }

    private calculate = (notation: string): number => {
        const frames = notation.split(" ");
        let score = 0;
        let rollIndex = 0;
        
        // Convertir la notation en tableau de valeurs numériques
        const rolls: number[] = [];
        for (const frame of frames) {
            for (const char of frame) {
                if (char === "X") {
                    rolls.push(10);
                } else if (char === "/") {
                    // Le spare vaut 10 moins la valeur du lancer précédent
                    rolls.push(10 - (isNaN(parseInt(frame[frame.indexOf(char) - 1])) ? 0 : parseInt(frame[frame.indexOf(char) - 1])));
                } else if (char === "-") {
                    rolls.push(0);
                } else {
                    rolls.push(parseInt(char));
                }
            }
        }
        
        // Calculer le score pour les 10 frames
        for (let frame = 0; frame < 10; frame++) {
            if (rollIndex >= rolls.length) break;
            
            if (rolls[rollIndex] === 10) {
                // Strike
                score += 10;
                if (rollIndex + 1 < rolls.length) score += rolls[rollIndex + 1];
                if (rollIndex + 2 < rolls.length) score += rolls[rollIndex + 2];
                rollIndex += 1;
            } else if (rollIndex + 1 < rolls.length && rolls[rollIndex] + rolls[rollIndex + 1] === 10) {
                // Spare
                score += 10;
                if (rollIndex + 2 < rolls.length) score += rolls[rollIndex + 2];
                rollIndex += 2;
            } else {
                // Open frame
                score += rolls[rollIndex];
                if (rollIndex + 1 < rolls.length) score += rolls[rollIndex + 1];
                rollIndex += 2;
            }
        }
        
        return score;
    }
}

