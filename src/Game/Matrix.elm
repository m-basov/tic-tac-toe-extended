module Game.Matrix
    exposing
        ( Matrix
        , create
        , flatten
        , get
        , set
        , all
        , map
        , indexedMap
        , toList
        , fromList
        )

import Array exposing (Array)
import Game.Types exposing (Row, Col, Coords)
import List


type alias Matrix a =
    Array (Array a)


{-| Create square matrix from given size.

    create 2 (\row col -> ( row, col ))
    --  ____________
    -- |     |     |
    -- |(0,0)|(0,1)|
    -- |_____|_____|
    -- |     |     |
    -- |(1,0)|(1,1)|
    -- |_____|_____|
-}
create : Int -> (Row -> Col -> a) -> Matrix a
create size callback =
    let
        arrToMap =
            Array.fromList (List.range 0 (size - 1))
    in
        Array.map
            (\row ->
                Array.map
                    (\col ->
                        callback row col
                    )
                    arrToMap
            )
            arrToMap


flatten : Matrix a -> Array a
flatten arr =
    Array.toList (Array.map (\child -> Array.toList child) arr)
        |> List.concat
        |> Array.fromList


all : (a -> Bool) -> Matrix a -> Bool
all func matrix =
    toList matrix
        |> List.concat
        |> List.all func


map : (a -> b) -> Matrix a -> Matrix b
map func matrix =
    Array.map (\row -> (Array.map func row)) matrix


indexedMap : (Row -> Col -> a -> b) -> Matrix a -> Matrix b
indexedMap func matrix =
    Array.indexedMap (\rowIdx row -> (Array.indexedMap (func rowIdx) row)) matrix


toList : Matrix a -> List (List a)
toList matrix =
    Array.toList (Array.map (\row -> Array.toList row) matrix)


fromList : List (List a) -> Matrix a
fromList lists =
    Array.fromList (List.map (\list -> Array.fromList list) lists)


get : Coords -> Matrix a -> Maybe a
get ( row, col ) matrix =
    Array.get row matrix |> Maybe.andThen (Array.get col)


set : Coords -> a -> Matrix a -> Matrix a
set ( row, col ) el matrix =
    let
        rowToChange =
            Array.get row matrix

        newRow =
            case rowToChange of
                Just row_ ->
                    Just (Array.set col el row_)

                Nothing ->
                    Nothing
    in
        case newRow of
            Just row_ ->
                Array.set row row_ matrix

            Nothing ->
                matrix
