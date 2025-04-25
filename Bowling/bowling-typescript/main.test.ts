import {Bowling} from "./bowling";

describe('test', function () {

    it('X X X X X X X X X X X X X should return 300', () => {
        const bowling = new Bowling()
        expect(bowling.roll("X X X X X X X X X X X X")).toEqual(300)
    });

    it('9- 9- 9- 9- 9- 9- 9- 9- 9- 9- should return 90', () => {
        const bowling = new Bowling()
        expect(bowling.roll("9- 9- 9- 9- 9- 9- 9- 9- 9- 9-")).toEqual(90)
    });

    it('5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5 should return 150', () => {
        const bowling = new Bowling()
        expect(bowling.roll("5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5")).toEqual(150)
    });

    it('8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/8 should return 180', () => {
        const bowling = new Bowling()
        expect(bowling.roll("8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/ 8/8")).toEqual(180)
    });

    it('7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/7 should return 170', () => {
        const bowling = new Bowling()
        expect(bowling.roll("7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/ 7/7")).toEqual(170)
    });

    it('X 9- X 9- X 9- X 9- X 9- should return 140', () => {
        const bowling = new Bowling()
        expect(bowling.roll("X 9- X 9- X 9- X 9- X 9-")).toEqual(140)
    });

    it('X 7/ X 7/ X 7/ X 7/ X 7/X should return 200', () => {
        const bowling = new Bowling()
        expect(bowling.roll("X 7/ X 7/ X 7/ X 7/ X 7/X")).toEqual(200)
    });

    it('8- 8- 8- 8- 8- 8- 8- 8- 8- 8- should return 80', () => {
        const bowling = new Bowling()
        expect(bowling.roll("8- 8- 8- 8- 8- 8- 8- 8- 8- 8-")).toEqual(80)
    });

    it('9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/9 should return 190', () => {
        const bowling = new Bowling()
        expect(bowling.roll("9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/ 9/9")).toEqual(190)
    });

    it('X 7- X 7- X 7- X 7- X 7- should return 120', () => {
        const bowling = new Bowling()
        expect(bowling.roll("X 7- X 7- X 7- X 7- X 7-")).toEqual(120)
    });

    it('X 5- 6/ 2- 4/ -9 X4/ 5/ 6- should return 110', () => {
        const bowling = new Bowling()
        expect(bowling.roll("X 5- 6/ 2- 4/ -9 X 4/ 5/ 6-")).toEqual(110)
    });
});