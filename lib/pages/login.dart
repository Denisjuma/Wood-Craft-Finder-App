import 'package:flutter/material.dart';
import '../actions/login_action.dart'; // Import the login function from auth_service.dart

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign the form key to the Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipOval(
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAY1BMVEXQ0NBwcXL////v7+/u7u719fX5+fn8/Pzy8vLR0dHX19dtbm/Nzc3a2trV1dVnaGnf39/l5eWrq6x+f4B2d3jFxcV5enuIiYpkZWaXl5idnZ69vb20tLSjpKTj4+ONjo+TlJU9i69RAAANo0lEQVR4nNWdabubLBCGjQsKAi6Jxyxm+f+/sqhxSaKJzoyJfT707cvVUu4zAww4gGU38py7graoKXFZW+Q2RX5Twtqiwap85nlOkiRKCG010kKopJbjOVOrArXKsZYiDBzXKFaGi0sj61llIedcKOE6vv/fEQZuEms9wDUkg6rjxPwjvjNQ1QoJfS8WnE+D62FaXBjMYPWEfnIRc+F6mDq+BMFqCR3bc6c65lvKxHVWSegmarZrjjBykTCiVpERBkls0eDdIaVw6Andu3p1NUW9uhr16gpclxPSNeKxh2lVI8trxFpNKupKAirvfJY0jL4Pa1VXZL3a3H+d4Nq+1g0BQV0UJGoZvDukFTBAqxzXa4vmETq9uqr/TcQS/vnAqBN/bquMaAgDMzkszNcx/oLQVV/Aq6VN5Pp1Qi9e2j/7kqqdNr5FmHzDPx8Z3c+toiN0Fh1ARxBF/DVCFn+fr5JKPhIOzBZBI+bfxdoif6jIdhea4CeIJ4433Kq7vKbEa4vmR22/MmAlKbzZUVtH2Jj8bYyb/BCvZkyC11bRrS38+NeARmpBQoZYvlOq3utYgPDnHtqqmv/pCS+/5upJLUDI0JO8FqWUqv6DDfm4S03IUE3SWglLntLDOb/meZqepBRK689/8U2ViUO6i+EiWsOVkMUxj6IobGR+nx/PmaFEMF4mzocNavcTaXeeuw8KLhxPiCzdbQzV5lFlye5YYPz10syMnU2gcSl8EBXxKY+e4fqYeSEVlFHGDdAL4cxdjAt0jBHq9PeGr2bcHzPoUlqqYIRwng2hgSgXp/zFOYcgd6kZh2CIMSMghK51hXznnw+K8gLoqndHRRECAbkqNhP5Kl9NoSNOjCUEuiiPD5PxajNeJcKKCELgICPkbroB72bcSdiAUw43bwnbmbFH2Mh2YYBabucCGsRtBhtvjBU7wqbpPUL2RsCJXluzLVgh7iUsxJGXdxDvojYgoMgAFrxbERjFJY3t5u1iMOA/p3IYYIkIHG6s5D5yzFpbQFcT6gAFNIhX4LyoXQAhMJQSBZjPKDoAoxs+nxA4T+gMNMp0VjwBEatN/zmE0OVEDO6EDSIwuJHJPELoKCOKCAe4Cc/QlYb7eY3fEfpAV9ESyWe0A86KljXHhtAFkzojfbQ0Yg41ognfOkKnJRyM2qArQo43oVEGXfQng1HbUOQN/AcsdcSb0BjxAF7ze60jviW0oR8ntCbgM9qD9xmFM4kQ6qOWIDEhpid2e1PvCOF7v/CA9El/8O31ZAIh+AuoONHwmditAM5WnZ++IQT7qKWuRCZEuGnrp28IwT89S+2IAI0RoQvFdpUxvosBz5PRJ2zA1ilM4R80VPA0Hz6mMXjwPq6JRtKK8AbPKJPuY57GU1yK+E6vybphKehi30hVM8JIXAr/xmTxjM5Jy9EU7qYyGScMENmGKqU0YXhENEX7o4QIExLFpK12CMLSiCOEmC+yAriFOEaI+tLvjxBiMio54WxYCT4jVkYcJAzgk325A0ULiJkRTWvYIGGC8QtdkDqpIcTkWMvE7wi7DX5cPgnpUFpuf2M8yuJ+e/Cii9oCVEYQ7XxfBt8oQtnl2baRN2YuNBJUa8NGO1Q+kaX8F0Lk0SVywggRt1nlls0rITJtjXiyMIQoN62j0z5hgDOhlpRRaUVo4dzU8p4IkbmjnJwwhO9kVKri7z4hMr2Z3oZhiiO09CMhJuauqiNdO5EQStbfxUCFpKUE8YRPQNiMNfeoDXsMbQFC6NfgVrqfqeBhk5LXSHjfHa4JsZPhEoRHNGHcI0ROPSsllKwl9NEHRRYgPOMJg5YQf1xylf2wPj9UEeLPiqycEJqXsCwhvh9aVkOI2MpvCYk3MShm/CrHpr41guDI3QKRNwGhWQfXt0YQVLXCyLsUryNv5NJwzYSWUxFSXL1C76URNIXvQW5JGJBcHqCpRxrsLkatuLIhydlevrKdqLtEZUN0UFpVRU24IWmW9FdLiNwRbiQDQ4heOVUSBFmJD4S4Xf1GMrGtgIZQUxOCE2kfFfsWOE/vUZosIaohJOk8lvIs9BZNLfLvh4hUhb5EYBEsLEpxsaJvwH0lFjRn/VmalnBHdEkTTyyPpCLcUZlXEQ2lFWFAUxPxZ25UPk1f0hASXVdCmxNFs7IopSy6S7v+KAnB+frPSugINWFHDLdkl8EJQkLCjhjeiEb4kpDsakDKRTBdN7S0RVaVpcgAN3vwXRkDIiQk2zNFZLIPiMzhLb6G0wgLi2q+2JHNFcSiSqINt3SORSvNaUZTmo3ERUSTJ2yi7pU6KdX3mfCwVie1qIy41nGmlEYf5a7uVfg1xjtxAiNS7V8sI4FeYGCOPA2L9gcm+B5JCL2k5k2baKuLbzgjhlfyS2CJCbVGhm70vZA6fOCo4XSJXkh+76rGDKeI47EjItzFaITZzaBIE3oS4S5GVyfCiPThDOFeWyt4YLNAOCMNIX0QCA9s6AfSZQihnzDoB9LyM/cShND0IcI9xFbcsyhyvp4lYIT0U0VF6NF7Bo9hwWlEuUt6l/CXsCEHzhfRArsXwrZ8mlyMvrgA2nAJQs+yHfr3DmJgP6QnlIljESTqv2hFhG5JSD+ArYeQl4REKUN9QcdSekJdEZJHplytZiyNq1x9qmyMTmo1NqwJffp6V9MPk/q8BflQsxpCHlS3RvjkGxmrIVSsujUCfUT2RWshrM5zlydKME+sDGo1hN6dEHklxqtiECA9oWYNIbGbQnNNyQnj9jw+VfZeW/M65sP6CpeakLgjrqQfyt6dCsRuuhJC1SMkflcbTEjaCun0b40grVtcgIQx6aCuWf/WCDo31UqnIL5SqdSEeXZO/30LRkPItTqliM8W4e6aKare6D7e10bxo9NKnm7RlEes3jBGt1SiHpxrW/NEiL2gpjSfPG9mvPE0yhhuzhnXaEPGz3fu4WrkKi4OuJct+pBRXsTI7WHuPhNinvnVKit2U58gm8i4SzOB6TrNo3MdIfiKGuOe2YHAO18gN7dMgJ1VDtwMCdty42ZyOOAGl3HGME810FnFACFgd59rnaWbhfhqxp0xJGD6qO6LuN+i1N4R6c/m+/BAJRFklJ/mjzrc697sam8V9OetocrR5dMDlVSM5TOX86ZINXjr/IyTiMY95YF29HwPuctnTZE8Gb5Xf2pwypUgnhwmMEa7Qkx2VjXycsC0bzTGPY9/38W7Q/4dT9Oc1cz2I28jTLgeUsTZdcHB8wNjeJ0S68h49PWHT0Y0oedx+2X3fGaMjh8D8zLmHnvf4t33YDO6cOOev+SrIf9yS7+bIqv3ycYI/dFFNleq+K35OoXRtlDjhizDmf77Fu07EKx65GLE7mZ02f7efK3Caqk8zCiT8qUOr3234+mVTmdoiSFieVsyNgPJBOan4cVHvWkx/krn8w+m3HdZPjaDKIzCs341pHcnfI28a8Lg8sx3XpN7Pinc3rR4YJQX+wOh088CM90vJVu4LyPTIYu4xyjtj4ROm6zIzcp2veZrZVaRp+6hNncCYbPFr1T6H/CVMqHO6b5+F/YUwmoDXFjn/4SvVLgxY45VvzAzgdDzpFaYfd1fKNyezYru0zuk7avVSXb7jwx4V5RnyeCr1a1vdm9YOuxIfUfgNxRe2eDr8Q9xaU3oBsnK54hB7c0w0xB+eofU9a3/z4hhZtuTbeg4PsFx1+8qOtqzCJ2A9gmuxRVu2UxCh/1fXTGqg5k5hN7lf0KsOuFMQpfx/4dwX9jjhIOvVtcPP8v/BTFKm7YPvVrNxmWn2IPZ31F09N9QDEZtjVj6P8wZYR60phuK2jrCxoU7wsC/rh8x3Hl2E2Z/iLxfCc3Mf147YpibLocgDLyVz/zhtsztQhCaYXfV64xwW7UWRRi4K3bUMK+z81CEzoqHm3KQmUPoDhOa4Walk0Z0bJoKtuE9BgoY8VXWNIqOTRjmN013OsK26E3U5nYvXdrZ+vZt9ilrMkqcziYDUVuD+hx5l0Xtn2IeX9tKI5Q9T3z2uklri0dCl8ULJHbBFUaZTUzoemvagIu2rk1NWI43xVo+st3HGGpCx2FyFZ0x3J98exlCx7usYPIPt5fHVlESGk9Nf+2p+4P73KoPhJPmw3Y96dhx/kszhrvMH2pVSzgwH7Y5C16TlNGlMTzmadRFjP3ws2J4DezBVr0UsbboNS51X+LSngeXEaCvfpRYE9V7hsOtqotAa4uXulzPK36QuheGhfemVZSERiy57b+efXn51CpKQjN68es3XTX641NaRUno2CzbfmtUDTdFrwlfIizrYsXmG3YMo3PiT28VJWHJuPiwGu7OiRfMatUo4cBs4X6syzktmfFdpunH5UJ3ZqseCNv9/fbghfdaxEaLfJvJpcac8qgFsyGt6hfNjtoa9eIjJg4LJGeGmzzzmA9uVaN5kfdojJuctntCyDCMNmnMfGSrKAnN37qQZRGH4fYoHD8wHW5NhHZ5Nuy8Rx6SLa23P2qXMbJWkRKa8U4fb/BJ0tBtz9Uhc5euVaSExq3McJacjrvNXFuWPW+Xn+KgqWqlhLV821en9LqPDOZnTvNnImO740kF/ktVKyWsq/KDOEuv+d+uAa1ge79UaOFffjtk4sLKJetYVSslrOS5SSJPRXH724Z5+PjL7XCSOi7P0Xl1xOguQvgPZuM7FelR14AAAAAASUVORK5CYII='),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        ),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Navigate to the registration screen
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, don't proceed with login
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call login function
      await login(usernameController.text, passwordController.text);

      // Navigate to home screen upon successful login
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (error) {
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
