# Milky Way App

This app was built as part of a code challenge

## Rule #1 - Read the Brief

I was so keen to start the challenge I read through the brief way too fast and thought I had understood. But after a weekend of vigorous coding, documentation reading and tutorials, Sunday evening reading over the Brief again I realised it said `We use MVVM with RxSwift or Combine` instead of what I thought: `Use MVVM with RxSwift or Combine`. 🙃

So, when going through he project, bear in mind that I thought part of the coding challenge was to do it in either `RxSwift` or `Combine`. 

There is a branch, `combine`, that has the app mostly completed and tested using `Combine`. Feel free to check it out as well. It was a fun challenge to do it in `Combine`, but this was my first proper exposure. I felt a lot of things could have been done and tested better with more familiar ways, so I decided to rewrite the affected components.

## Architecture

- The project started out with `MVVM` and `Combine`, and later `Combine` was dropped. 
- The image caching feature still uses `Combine`, as the solution was too sleek to replace with another approach.

## Improvements
- The Json structure of the API is quite messy with arrays of links and data objects, even though the images generally only have 1 of each. A good improvement would be to clean up the decoding, to have less messy Model-ViewModel interactions.
- The API call should be paginated together with an infinite scroll, but I did not have enough time to implement this properly after switching from Combine. 


## Pods

I added the Swiftlint pod just to have familiar formatting.

## Error Handling

Even though I have handled the most important errors, I did abstract their real description away from the User for more user-facing descriptions.

## Design

One design decision that I changed from Figma was the Alert popup also has a Cancel option, that does not retry the API call. The reason for this is that if something does repeatedly fail, Users will be locked into a loop of retrying the API call and getting popup again. The cancel option allows the user to get out of this cycle.

## Asset Attribution

None of the design (App Icon & Launch Screen Icon) are mine, all credits go to (Karya Sore)[https://iconscout.com/contributors/karyasore]
