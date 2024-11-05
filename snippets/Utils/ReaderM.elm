module Utils.ReaderM exposing (ReaderM(..), run)


type ReaderM
    = ReaderM (String -> String)


run : String -> ReaderM -> String
run text readerM =
    let
        func =
            case readerM of
                ReaderM f ->
                    f
    in
    func text
