import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';

// Main abstract class for WebSocket configuration
abstract class WebsocketConfig {
  // Variable that holds the channel
  WebSocketChannel? _channel;

  // Base URL for the websocket
  final String websocketUrl = const String.fromEnvironment('WSURL');

  // Endpoint
  final String endpoint;

  // Constructor
  WebsocketConfig(this.endpoint);

  // Abstract method for message handling
  void handleIncomingMessage(Map<String, dynamic> data);

  // Method to initialize the WebSocket
  void _initializeWebSocket() {
    // Variable that composes the full URL for the websocket
    final Uri wsUrlUri = Uri.parse('$websocketUrl$endpoint');

    // Instantiates the channel
    _channel = WebSocketChannel.connect(wsUrlUri);
  }

  // Method to disconnect from the websocket
  Future<void> disconnectWebSocket() async {
    // Checks if the channel exists
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }
  }

  // Main method to connect to the websocket
  Future<void> connectWebSocket() async {
    // Checks if the channel exists
    if (_channel != null) {
      return;
    }

    // Starts the connection
    _initializeWebSocket();

    // Waits for the connection to be established
    await _channel!.ready;

    // Section that reads the messages coming from the websocket
    _channel!.stream.listen((message) {
      try {
        // Decodes the message
        final dynamic decoddedMessage = json.decode(message);

        // Calling the abstract method for message handling
        handleIncomingMessage(decoddedMessage);
      } catch (error) {
        // Log error
        log('Error decoding message: $error');
      }
    },
        // Connection error
        onError: (error) {
      _channel = null;
    },
        // Connection closed
        onDone: () {
      _channel = null;
    }, cancelOnError: false);
  }
}