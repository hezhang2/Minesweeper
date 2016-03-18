

import de.bezier.guido.*;
public final static int NUM_ROWS=20;
public final static int NUM_COLS=20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    noStroke();
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++){
        for(int c=0;c<NUM_COLS;c++){
            buttons[r][c] = new MSButton(r,c);
        }
    }
    bombs = new ArrayList<MSButton>();
    setBombs();
    gameOver=false;
}
public void setBombs()
{	
	for(int i=0; i<20; i++){
		int rRan=(int)(Math.random()*NUM_ROWS);
		int cRan=(int)(Math.random()*NUM_COLS);
    	if(!bombs.contains(buttons[rRan][cRan]))
    		bombs.add(buttons[rRan][cRan]);
    }
}

public void draw ()
{
    background( 0 );
    if(!gameOver&&isWon()){
        displayWinningMessage();
	}
}
public boolean isWon(){
    for(int r=0;r<NUM_ROWS;r++){
    	for(int c=0;c<NUM_COLS;c++){
    		if(!bombs.contains(buttons[r][c])&&!buttons[r][c].isKnown()){
    			return false;
    		}
    	}
    }
    return true;
}
public void displayLosingMessage(){
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("E");
}
public void displayWinningMessage(){
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("I");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, known;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
    	known=true;
        if(keyPressed)
        	marked=!marked;
        else if(bombs.contains(this)&&gameOver==false){
        	clicked=true;
        	for(int r=0;r<NUM_ROWS;r++){
            	for(int c=0;c<NUM_COLS;c++){
            		if(!buttons[r][c].isClicked())
            			buttons[r][c].mousePressed();
        		}
        	}
        	gameOver=true;
        	displayLosingMessage();
        }else if(countBombs(r,c)>0)
        	setLabel(""+countBombs(r,c));
        else{
        	clicked=true;
        	if(isValid(r-1,c-1)&&!buttons[r-1][c-1].clicked)
        		buttons[r-1][c-1].mousePressed();
        	if(isValid(r-1,c)&&!buttons[r-1][c].clicked)
        		buttons[r-1][c].mousePressed();
        	if(isValid(r-1,c+1)&&!buttons[r-1][c+1].clicked)
        		buttons[r-1][c+1].mousePressed();
        	if(isValid(r,c-1)&&!buttons[r][c-1].clicked)
        		buttons[r][c-1].mousePressed();
        	if(isValid(r,c+1)&&!buttons[r][c+1].clicked)
        		buttons[r][c+1].mousePressed();
        	if(isValid(r+1,c-1)&&!buttons[r+1][c-1].clicked)
        		buttons[r+1][c-1].mousePressed();
        	if(isValid(r+1,c)&&!buttons[r+1][c].clicked)
        		buttons[r+1][c].mousePressed();
        	if(isValid(r+1,c+1)&&!buttons[r+1][c+1].clicked)
        		buttons[r+1][c+1].mousePressed();
        }
    }

    public void draw () {    
        if (marked)
            fill(0);
        else if(clicked==true&&bombs.contains(this)) 
            fill(255,30,30);
        else if(clicked && r%2==c%2)
            fill( 140 );
        else if(clicked)
             fill(160);
        else if(r%2==c%2)
             fill( 100 );
        else
        	fill(120);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        label = newLabel;
    }
    public boolean isValid(int r, int c){
    	if(r<NUM_ROWS&&r>=0&&c<NUM_COLS&&c>=0)
    		return true;
        return false;
    }
    public boolean isKnown(){
    	return known;
    }
    public int countBombs(int row, int col){
        int numBombs = 0;
        if(isValid(row-1,col-1)&&bombs.contains(buttons[row-1][col-1]))
        	numBombs++;
        if(isValid(row-1,col)&&bombs.contains(buttons[row-1][col]))
        	numBombs++;
        if(isValid(row-1,col+1)&&bombs.contains(buttons[row-1][col+1]))
        	numBombs++;
        if(isValid(row,col-1)&&bombs.contains(buttons[row][col-1]))
        	numBombs++;
        if(isValid(row,col+1)&&bombs.contains(buttons[row][col+1]))
        	numBombs++;
        if(isValid(row+1,col-1)&&bombs.contains(buttons[row+1][col-1]))
        	numBombs++;
        if(isValid(row+1,col)&&bombs.contains(buttons[row+1][col]))
        	numBombs++;
        if(isValid(row+1,col+1)&&bombs.contains(buttons[row+1][col+1]))
        	numBombs++;
        return numBombs;
    }
}
