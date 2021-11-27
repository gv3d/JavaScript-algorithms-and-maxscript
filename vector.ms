
-- Вращение объектов (и векторов)

undo "rotationTest" on (

pt = [50, 0, 0]         -- вектор
center = [50, 50, 0]    -- центр вращения
axis = [0, 0, 1]        -- ось вращения (Z)

-- при использовании матрицы вращения
-- происходит левый поворот (против часовой стрелки)

for a = 0 to 150 by 30 do (                 -- угол вращения
	q = quat a axis                          -- кватернион: поворот на угол a относительно положительного направления оси Z
	rm = q as matrix3                        -- преобразуем кватернион в матрицу вращения
--	rm = inverse rm                          -- инвертировать матрицу поворота для правого поворота (по часовой стрелке)
											 -- этот оператор должен стоять ДО задания цетра поворота
	rm.row4 = center                         -- четвертая строка матрицы - задаем центр вращения
	rotpt = pt * rm                          -- поворачиваем вектор
	point pos:rotpt box:true wirecolor:red   -- создаем объект Point в текущем положении повернутого вектора
                                            -- здесь вращаем только вектор, объект создается без поворота
	format "a = % rotpt = %\n" a rotpt       -- выводим лог в Listener
)

-- при использовании конструкции about ... rotate
-- происходит правый поворот (по часовой стрелке)
pobj = point pos:(pt + center) box:true wirecolor:blue name:"rotPoint00" size:15
for a = 0 to 150 by 30 do (                 -- угол вращения
	npobj = instance pobj                    -- создаем инстанс объекта Point
	npobj.wirecolor = blue
	q = quat a axis                          -- кватернион: поворот на угол a относительно положительного направления оси Z
	about center rotate npobj q              -- поворачиваем объект вокруг заданного центра на текущий угол
)
delete pobj                                 -- удаляем исходный объект


-- поворот объекта, аналогичный использованию конструкции about ... rotate,
-- посредством присваивания свойствам pos и rotation соответствующих значений

pobj = point pos:pt box:true wirecolor:green name:"rotmatrixPoint00" size:10
for a = 0 to 150 by 30 do (                 -- угол вращения
	npobj = instance pobj                    -- создаем инстанс объекта Point
	npobj.wirecolor = green
	q = quat a axis                          -- кватернион: поворот на угол a относительно положительного направления оси Z
	rm = q as matrix3                        -- преобразуем кватернион в матрицу вращения
	rm = inverse rm
	rm.row4 = center                         -- четвертая строка матрицы - задаем центр вращения
	npobj.pos *= rm                          -- поворачиваем объект вокруг заданного центра на текущий угол (без вращения самого объекта!)
	in coordsys (transmatrix npobj.pos) npobj.rotation = q -- поворачиваем сам объект вокруг пивота на текущий угол
)
delete pobj                                 -- удаляем исходный объект. аминь!

) -- undo