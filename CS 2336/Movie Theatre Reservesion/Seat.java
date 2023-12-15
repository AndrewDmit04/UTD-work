public class Seat {
    // Members
    private int row;
    private char seat;
    private char ticketType;

    // constructor
    public Seat(int r, char s, char t) {
        row = r;
        seat = s;
        ticketType = t;
    }

    // Mutators
    public void setRow(int r) {
        row = r;
    }

    public void setSeat(char s) {
        seat = s;
    }

    public void setTicket(char t) {
        ticketType = t;
    }

    // Accessors
    public int getRow() {
        return row;
    }

    public char getSeat() {
        return seat;
    }

    public char getTicket() {
        return ticketType;
    }
}
