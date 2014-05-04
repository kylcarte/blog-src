--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*.hs" $ do
      route $ setExtension "css"
      compile $ getResourceString >>= withItemBody (unixFilter "runghc" [])

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate defaultTemplate defaultContext
            >>= relativizeUrls

    match postPat $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate defaultTemplate postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll postPat
            let archiveCtx =
                     listField "posts" postCtx (return posts)
                  <> constField "title" "Archives"
                  <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate defaultTemplate archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll postPat
            let indexCtx =
                     listField "posts" postCtx (return posts)
                  <> constField "title" "Home"
                  <> defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate defaultTemplate indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler
  where
  postPat :: Pattern
  postPat = "posts/*/*.markdown"
  defaultTemplate :: Identifier
  defaultTemplate = "templates/test.html"

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
     dateField "date" "%B %e, %Y"
  <> defaultContext
