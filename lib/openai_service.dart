import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myjarvis/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAPIKey'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                'role': 'user',
                'content': "Does this message want to generate an AI picture, image,art or anything similar? $prompt . Simply answer with a yes or no"
              }
            ]
          }));
      print('response' + res.body);
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'yes':
          case 'Yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;

          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
    } catch (e) {
      e.toString();
    }
    return 'An Internal error occured';
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt
    });
    try {
      final res = await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAPIKey'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages
          }));
      print('response' + res.body);
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({
          'role': 'assistant',
          'content': content
        });
        //  print(messages);
        return content;
      }
    } catch (e) {
      e.toString();
    }

    return 'An Internal error occured';
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt
    });
    try {
      final res = await http.post(Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAPIKey'
          },
          body: jsonEncode({
            "prompt": messages,
            "n": 1
          }));
      print('response' + res.body);
      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)[0]['data'][0]['url'];
        imageUrl = imageUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imageUrl
        });
        //  print(messages);
        return imageUrl;
      }
    } catch (e) {
      e.toString();
    }
    return 'An Internal error occured';
  }
}
