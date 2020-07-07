print('list comprehension')
print('(value) = [ (expression) for (value) in (collection)]')

squares = [x * x for x in range(10)]
print(squares)

## normal for loop
squares = []
for x in range(10):
    squares.append(x * x)
print(squares)

#list comprehension: filtering
even_squares = [ x * x for x in range(10) if x % 2 == 0 ]
print(even_squares)
