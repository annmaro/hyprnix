# The Ultimate Bypass: Wiretapping D-Bus

1. Open a new terminal window.
2. Run this command to monitor your system's D-Bus traffic and filter for web links:

   ```bash
   dbus-monitor | grep "http"
   ```

3. Leave that terminal open and visible.
4. Go back to `antigravity` and click the **Sign in with Google** button.
5. Look at your terminal! You should instantly see the raw D-Bus payload printed out. It will look something like this:

   ```plaintext
   string "https://accounts.google.com/o/oauth2/v2/auth?client_id=..."
   ```

## How to use the intercepted URL

1. Copy that entire `https://accounts.google.com/...` URL from the terminal output (make sure you don't copy the quotes).
2. Open Firefox or Brave and paste the URL into the address bar.
3. Log into your Google account.
4. When the browser finishes, it will try to open a link that starts with `antigravity://auth...`
5. Catch that redirect link! Copy it from the address bar or the "Open link" prompt.
6. Open a new terminal tab and finally inject the token into the IDE:

   ```bash
   antigravity --open-url "PASTE_YOUR_ANTIGRAVITY_REDIRECT_URL_HERE"
   ```

Once you inject that token, the IDE will authenticate and you will finally be logged in.
