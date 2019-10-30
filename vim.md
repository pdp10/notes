# Neovim / Vim

### Basic Commands
The most simple commands allow you to open and close documents as well as 
saving them. As with most other text editors, there are protections in place to 
help you avoid exiting the editor without having saved what you're working on.

```
:h [keyword]    - Performs a search of help documentation for whatever keyword 
you enter
:e [file]       - Opens a file, where [file] is the name of the file you want 
                  opened
:e              - reload the current file
:w              - Saves the file you are working on
:w [filename]   - Allows you to save your file with the name you've defined
:wq             - Save your file and close Vim
:q!             - Quit without first saving the file you were working on
:qall           - Quit all buffers / tabs
.               - Repeat the last change made in normal mode 
                 (e.g. after dw - delete word - press . to delete another word)
@:              - repeat the last command-line change (a command invoked with :)
:cd abs_path    - change the workdir to abs_path
```



### Movement
When using movement commands, you can put a number in front of them to make Vim 
complete a command multiple times. For example, 5h will move your cursor five 
spaces to the left, and 90j will put your cursor at the beginning of the 90th 
line down from where your cursor currently is.

```
h - Moves the cursor to the left
l - Moves the cursor to the right
j - Moves the cursor down one line (arrow pointing down)
k - Moves the cursor up one line

w - Puts the cursor at the start of the next word
b - Puts the cursor at the start of the previous word
e - Puts the cursor at the end of a word

0 - Places the cursor at the beginning of a line
$ - Places the cursor at the end of a line

) - Takes you to the start of the next sentence
( - Takes you to the start of the previous sentence
} - Takes you to the start of the next paragraph or block of text
{ - Takes you to the start of the previous paragraph or block of text

<C-f> - Takes you one page forward
<C-b> - Takes you one page back

H - Puts the cursor at the top of the screen
M - Puts the cursor in the middle of the screen
L - Puts the cursor at the bottom of the screen

gg (or 1G) - Place the cursor at the start of the file
G          - Place the cursor at the end of the file
:# (or #G) - Place the cursor to line #

%           - Go to the corresponding (, {, [.
* (resp. #) - go to next (resp. previous) occurrence of the word under the 
              cursor (QUICK WORD SEARCH - VERY USEFUL)

:noh - remove highlightings 
```



### Selection and Editing
Those who use Vim tend to use the term “yank” where most people would use the 
term copy. Therefore, the command for copying a word is yw, which stands for 
yank word, and the command for pasting whatever has been copied is p, meaning 
put. 
As with movement commands, putting a number in front of the command can increase 
the number of times a task is completed. For instance, putting a number in front 
of yy will increase the number of lines copied, so 5yy will copy five lines. 
You also have two options for how to select text. You can either use commands 
like dd, which deletes a single line, and yw, which copies a single line, or you 
can highlight text and then copy it to the unnamed register. The paste commands 
work the same whether you've highlighted text or used a command to automatically 
copy it.

##### Visual Mode
Visual mode allows you to select a block of text in Vim: 
```
v       - starts visual mode, you can then select a range of text, and run a 
          command 
V       - starts linewise visual mode (selects entire lines) 
h j k l - move to select some text. In addition, see section Movements.
aw      - select the word where the cursor is
```
Then, in normal mode:
```
y - yank (copy) the selected text 
d - delete (cut) the selected text 
p - Paste whatever has been copied to the unnamed register
```

##### Normal mode - Selection shortcuts
```
yy        - Yank (copy) a line
yw        - Yank (copy) a word
y0        - Yank (copy) from the beginning of the line to where your cursor is
y$ (or Y) - Yank (copy) from where your cursor is to the end of a line
ygg       - Yank (copy) from the beginning of the file to where your cursor is
yG        - Yank (copy) from where your cursor is to the end of the file
3yy       - Yank (copy) 3 lines

dd        - Delete (cut) a line of text
dw        - Delete (cut) a word
d0        - Delete (cut) from the beginning of the line to where your cursor is
d$ (or D) - Delete (cut) from where your cursor is to the end of a line
dgg       - Delete (cut) from the beginning of the file to where your cursor is
dG        - Delete (cut) from where your cursor is to the end of the file
3dd       - Delete (cut) 3 lines

x - Deletes a single character

u      - Undo the last operation; u# allows you to undo multiple actions
<C-r> - Redo the last undo
.      - Repeats the last action
```

##### Insertion mode
Autocompletion: 
```
<C-n> - complete the word, repeating moves forward
<C-p> - as above, but repeating moves backword
```

##### Editing to/from outside Vim
To enable yank/cut/paste to/from clipboard (e.g. yank text from vim and paste 
outside vim), install: vim-gnome or vim-gtk. 

In VIM (normal mode):
- select text (v) and type "+y to copy to clipboard. Press <C-v> outside Vim
- select text (v) and type "+d (or "+x) to cut to clipboard. Press <C-v> 
  outside Vim

Outside Vim:
- Select and copy/cut text to clipboard. Type "+p to paste in Vim (normal mode). 

Note:
```
"       - means "use register"
+ and * - are Vim registers. In Linux, + corresponds to the desktop clipboard, 
          while * corresponds to the X11 primary selection.
```

Useful commands:
```
gg"+yG : copy the entire buffer into + (normal mode)
```

##### Insert mode variation
```
a - insert after the cursor
o - insert a new line after the current one
O - insert a new line before the current one

r - replace command. e.g. rx to replace the char at the cursor with x
c - change operator. e.g. ce to change until the end of a word
```



### Searching / replacing Text
Like many other text editors, Vim allows you to search your text and find and 
replace text within your document. If you opt to replace multiple instances of 
the same keyword or phrase, you can set Vim up to require or not require you to 
confirm each replacement depending on how you put in the command.

##### Search
```
/word     - Searches for text in the document where word is whatever keyword, 
            phrase or string of characters you're looking for
?word     - Searches previous text for your word, phrase or character string
/\<word\> - searches for the exact word, where 'word' is bounded by word 
            boundaries (e.g. space, dash)
n - Searches your text again in whatever direction your last search/vep/
N - Searches your text again in the opposite direction
:noh - Un-highlight words
```

##### Replace
```
:%s/[pattern]/[replacement]/g  - This replaces all occurrences of a pattern 
                                 without confirming each one
:%s/[pattern]/[replacement]/gc - Replaces all occurrences of a pattern and 
                                 confirms each one

:[range]s/foo/bar/[flags] - replaces foo with bar in range according to flags

Ranges
%      - The entire file
’<,’>  - The current selection; the default range while in visual mode
25     - Line 25
25,50  - Lines 25-50
$      - Last line; can be combined with other lines as in ‘50,$’
.      - Current line; can be combined with other lines as in ‘.,50’
,+2    - The current lines and the two lines therebelow
-2,    - The current line and the two lines thereabove

Flags
g - Replace all occurrences on the specified line(s)
i - Ignore case
c - Confirm each substitution
```

##### Regular expressions
Some characters need to be escaped to be searched for literally: 
```
(, ), *, ., ^, $ .
```
Others need to be escaped to be to be used as part of a regular expression: 
```
+ . 
```


### Comment / uncomment a block of source code
To comment:
```
(normal mode)
<C-v>     - enter in visual block mode
j k       - select lines to comment. See Vim movements
I #       - (capital I) comment a code block with '#'
Esc-Esc   - comment the block
```

To uncomment:
```
(normal mode)
<C-v>    - enter in visual block mode
j k       - select lines to uncomment. See Vim movements
d (or x)  - remove the comments
```



### Advanced Vim commands

##### Faster editing on a line
```
0       - go to column 0
^       - go to first character on the line
$       - go to the last column
g_      - go to the last character on the line
fa      - go to next occurrence of the letter a on the line. , (resp. ;) will 
          find the next (resp. previous) occurrence.
t,      - go to just before the character ,.
3fa     - find the 3rd occurrence of a on this line.
F and T - like f and t but backward.

dt" - remove everything until the ".
```

##### Combination of an operator with positions: `start [operator] end`. 
These are specific when the start and end position are known. E.g.:
```
0y$    - yank from the beginning of the current line to the end of the line
^y$    - yank from the first non blank of the current line to the end of the line
ggyG   - Yank the whole current buffer
gg"+yG - Yank the whole current buffer to clipboard
HyM    - Yank the content from H to M. (H=high,M=middle,L=low buffer)
```

These commands are powerful when combined with marks:
```
:50    - go to L50
ma     - create mark `a`
:65    - go to L65
mb     - create mark `b`
'ay'b  - yank the content from line of mark `a` to line of mark `b`
`ay'b  - yank the content from position (L:C) of mark `a` to line of mark `b`
```

##### Command: combination of an operator with a range: `:[range][operator]`.
Useful when the cursor is NOT in place. E.g.:
```
:.,+4y   - yank from the current line and 4 lines below
:-2,.y   - yank from two lines above and the current line
:20,25d  - delete lines 20-25
:5,13bd  - delete buffers 5-13
```

##### Combination of an operator with a count and motion: `operator [number] motion`. 
Useful when the cursor is already in place. E.g.:
```
d2w    - delete 2 words
y3w    - yank 3 words
d3j    - delete from the current line and 3 lines below
y4j    - yank the previous 4 lines and the current one
c$     - change text from the cursor to the end of the line
c3w    - change the next 3 words with new text
y2/foo - yank up to the second occurence of foo
```



### Buffers, Windows, Tabs, Sessions
```
<C-G>   - See current work directory
```

##### Buffers
Buffers are created to work with more files at the same time.
```
:ls             - list all opened buffers (also :buffers)
:bn             - Switch to next buffer
:bp             - Switch to previous buffer
:bd             - Close the current buffer
:bd N           - Close buffer N
:bN             - Switch to buffer N

:sp [filename]  - Opens a new file and splits your screen horizontally to show 
                  more than one buffer
:vsp [filename] - Opens a new file and splits your screen vertically to show 
                  more than one buffer
```

##### Windows
Windows are views or containers of buffers. 
One buffer can be contained in more windows.
```
<C-w> | - Maximise the current window
<C-w> = - Resize windows to equal dimensions, automatically
<C-w> s - Split windows horizontally
<C-w> v - Split windows vertically

<C-w> c - Close a window without killing the buffer
<C-w> q - Quit a window

<C-w> w - Switch between windows
<C-w> r - Reverse buffers
<C-w> h - Moves your cursor to the window to the left
<C-w> l - Moves your cursor to the window to the right
<C-w> j - Moves your cursor to the window below the one you're in
<C-w> k - Moves your cursor to the window above the one you're in
```

##### Tabs
Tabs are the equivalent of workspaces. A tab can contain one or more buffers. 
A new tab is loaded when one needs to work on a separate part of the project without 
messing with the current view.
Below are some useful Vim commands for using tab pages:
```
:tabnew       - create a new tab
:tabedit file - opens a new tab and will take you to edit "file"
:tabclose     - close a single tab
:tabs         - list all open tabs 
gt            - move to the next tab 
gT            - move to the previous tab 
#gt           - move to a specific tab number 
                (e.g. 2gt takes you to the second tab) 
```

##### Sessions
Tabs and buffers can be saved and restored later one.
```
:mksession ~/mysession.vim    - save the current session
:source ~/mysession.vim       - open the saved session

$ vim -S ~/mysession.vim      - open the saved session when vim is started
```

##### netrw - directory browser
Shows the files from the current location
```
:Vex - vertical browser
:Hex - horizontal browser
:Ex  - same buffer
```

##### terminal
Split the window horizontally and start a terminal. 
```
:term (or :terminal)

# to access the text (e.g. yank/paste, scrolling), enter in terminal mode:
<C-w> N  - (uppercase N), visualise the terminal content in a buffer. Usual 
           Vim commands are possible
i,a      - return to terminal

```

