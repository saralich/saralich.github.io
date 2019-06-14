--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "posts/*" $ do
        route   $ setExtension "html"
        compile $ do
            let pageCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    postCtx

            pandocCompiler
              >>= loadAndApplyTemplate "templates/post.html"    postCtx
              >>= loadAndApplyTemplate "templates/default.html" pageCtx
              >>= relativizeUrls

    match "education.md" $ do
        route   $ setExtension "html"
        compile $ do
            let pagesCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    constField "title" "Sara Lichtenstein" `mappend`
                    constField "site_description" educationDescription `mappend`
                    defaultContext

            pandocCompiler
                >>= loadAndApplyTemplate "templates/page.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" pagesCtx
                >>= relativizeUrls

    match "employment.md" $ do
        route   $ setExtension "html"
        compile $ do
            let pagesCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    constField "title" "Sara Lichtenstein" `mappend`
                    constField "site_description" employmentDescription `mappend`
                    defaultContext

            pandocCompiler
                >>= loadAndApplyTemplate "templates/page.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" pagesCtx
                >>= relativizeUrls

    match "extra-curricular.md" $ do
        route   $ setExtension "html"
        compile $ do
            let pagesCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    constField "title" "Sara Lichtenstein" `mappend`
                    constField "site_description" extraCurricularDescription `mappend`
                    defaultContext

            pandocCompiler
                >>= loadAndApplyTemplate "templates/page.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" pagesCtx
                >>= relativizeUrls

    match "contact.md" $ do
        route   $ setExtension "html"
        compile $ do
            let pagesCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    constField "title" "Sara Lichtenstein" `mappend`
                    constField "site_description" contactDescription `mappend`
                    defaultContext

            pandocCompiler
                >>= loadAndApplyTemplate "templates/page.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" pagesCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx =
                    field "navigation" (\_ -> navigationList) `mappend`
                    constField "title" "Sara Lichtenstein" `mappend`
                    constField "site_description" siteDescription `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
-- Metadata
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    constField "site_description" siteDescription `mappend`
    defaultContext

educationDescription :: String
educationDescription = "The Smarts"

employmentDescription :: String
employmentDescription = "The Way the Bills Get Paid"

extraCurricularDescription :: String
extraCurricularDescription = "The Fun Stuff"

siteDescription :: String
siteDescription = "Haskell Programmer | Outdoor Adventurer | Rescue Pet Enthusiast"

contactDescription :: String
contactDescription = "If you would like to contact me, please fill out the form below."
--------------------------------------------------------------------------------
-- Navigation
navigation :: Compiler [Item String]
navigation = do
    identifiers <- getMatches "posts/*"
    return [Item identifier "" | identifier <- identifiers]

navigationList :: Compiler String
navigationList = do
    posts   <- fmap (take 10) . recentFirst =<< navigation
    itemTpl <- loadBody "templates/listitem.html"
    list    <- applyTemplateList itemTpl defaultContext posts
    return list
