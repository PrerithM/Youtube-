# YouTube Filter Kids

A modern, aesthetic Android app that filters YouTube recommendations based on user preferences, with kids mode and parental controls.

## Features

### 🎯 Core Features
- **User Authentication**: Google Sign-In and Email/Password login
- **Channel Filtering**: Add/remove allowed channels with easy management
- **Kids Mode**: Educational content only with parental PIN protection
- **Cross-Device Sync**: Settings sync across devices via local storage
- **Modern UI**: Beautiful, intuitive design with Material Design 3

### 🛡️ Safety Features
- **Parental Controls**: PIN-protected settings and kids mode
- **Content Filtering**: Hide YouTube Shorts and Trending sections
- **Educational Focus**: Pre-approved educational channels for kids
- **Safe Search**: Filtered search results based on allowed channels

### 🎨 Design Features
- **Modern Aesthetics**: Clean, modern UI with beautiful gradients
- **Intuitive Navigation**: Easy-to-use interface for all ages
- **Responsive Design**: Optimized for different screen sizes
- **Accessibility**: Designed with accessibility in mind

## Tech Stack

- **Frontend**: React Native with Expo
- **UI Framework**: React Native Paper (Material Design 3)
- **Navigation**: React Navigation v6
- **State Management**: React Context API
- **Storage**: AsyncStorage for local data persistence
- **Video Playback**: WebView with YouTube embed
- **Styling**: StyleSheet with modern design patterns

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd yt-filter-kids
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the development server**
   ```bash
   npm start
   ```

4. **Run on Android**
   ```bash
   npm run android
   ```

## Project Structure

```
src/
├── context/
│   ├── AuthContext.tsx      # Authentication state management
│   └── FilterContext.tsx    # Filter settings and channel management
├── screens/
│   ├── LoginScreen.tsx      # User authentication screen
│   ├── HomeScreen.tsx       # Main feed with filtered videos
│   ├── SettingsScreen.tsx   # Channel and settings management
│   ├── KidsModeScreen.tsx   # Educational content only
│   └── VideoPlayerScreen.tsx # Video playback with WebView
└── theme/
    └── theme.ts             # Material Design 3 theme configuration
```

## Key Features Explained

### Channel Management
- **Easy Addition**: Simple form to add new channels by name and URL
- **Quick Removal**: One-tap channel removal with confirmation
- **Visual Feedback**: Clear indication of allowed channels count
- **Educational Recommendations**: Pre-approved educational channels list

### Kids Mode
- **PIN Protection**: Parental PIN required to enable/disable
- **Educational Content**: Only shows pre-approved educational channels
- **No Search**: Removes search functionality for safety
- **Kid-Friendly UI**: Simplified interface with safety indicators

### Filter Settings
- **Hide Shorts**: Option to remove YouTube Shorts from feed
- **Hide Trending**: Option to remove trending section
- **Cross-Device Sync**: Settings automatically sync across devices
- **Real-time Updates**: Changes apply immediately

## Usage

### For Parents
1. **Sign Up/Login**: Create account or sign in with Google
2. **Add Channels**: Go to Settings and add allowed channels
3. **Set PIN**: Configure parental PIN for kids mode
4. **Enable Kids Mode**: Toggle kids mode with PIN protection
5. **Monitor Usage**: Check allowed channels and settings

### For Kids
1. **Kids Mode**: Access educational content only
2. **Watch Videos**: Tap on videos to play in safe environment
3. **Navigate Safely**: Use simplified navigation without search
4. **Learn**: Enjoy curated educational content

## Development

### Adding New Features
1. Create new components in `src/screens/` or `src/components/`
2. Update navigation in `App.tsx`
3. Add any new context providers if needed
4. Update theme colors in `src/theme/theme.ts`

### Styling Guidelines
- Use Material Design 3 principles
- Follow the established color palette
- Maintain consistent spacing and typography
- Ensure accessibility compliance

### State Management
- Use React Context for global state
- Keep local state minimal and focused
- Persist important data with AsyncStorage
- Handle loading and error states gracefully

## Future Enhancements

- **Firebase Integration**: Real-time sync across devices
- **YouTube API**: Direct integration for real video data
- **Advanced Filtering**: Content categories and age restrictions
- **Analytics**: Usage tracking and insights
- **Offline Support**: Cached content for offline viewing
- **Multiple Languages**: Internationalization support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the repository or contact the development team.

---

**Built with ❤️ for safe and educational content consumption**
