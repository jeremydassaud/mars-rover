export class FizzBuzz {
    calculate(number: number): string {
        let result = '';
        for (let currentNumber = 1; currentNumber <= number; currentNumber++) {
            result += this.calculateNumber(currentNumber);
        }

        return result;
    }

    private calculateNumber = (currentNumber: number): string => {
        if(currentNumber % 15 === 0) {
            return 'FizzBuzz';
        }

        if(currentNumber % 5 ===0) {
            return 'Buzz'
        }

        if (currentNumber % 3 === 0) {
            return 'Fizz'
        }
        return currentNumber.toString()
    }
}