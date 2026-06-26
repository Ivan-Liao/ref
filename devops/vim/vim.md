# Motions
1. 0 (go to start of line)
2. a, A (from normal to insert mode after cursor or end of line)
3. hjkl (left, down, up, right in normal mode)
4. o, O (new line below or above current line)
5. w, b (go forward or backwards to start of word)
6. W, B (go forward or backwards to start of WORD)

# Operators
1. c is the change operator
   1. c + i + [w,W,<character>] (replace word, WORD, between character)
2. d is the delete operator
   1. dd (delete current line)
3. v is for visual mode
   1. v + $, ^ (select from current cursor to end of line, start of line)
   2. v + i + [w,W,<character>] (select word, WORD, between character)
   3. V (select current line)