import random
import os

class Deck():
    def __init__(self, *args, **kwargs):
        self.deck = self.new_deck()

    @staticmethod
    def new_deck():
        deck = list(range(1, 14)) * 4
        random.shuffle(deck)
        return deck

    def get_card(self):
        return self.deck.pop()

    def __str__(self):
        # __str__ has to return string
        return ', '.join(map(str, self.deck))

    def __len__(self):
        return len(self.deck)


class Player():
    def __init__(self, name, fund):
        try:
            if int(fund) <= 0:
                raise 'Initial fund should be greater than 0'
        except:
            raise 'Fund has to be an integer.'
        self.name = name
        self.fund = fund
        self.card = []
        self.betamount = 0
        self.busted = False

    def add_card(self, card):
        self.card.append(card)

    def add_fund(self, amount):
        try:
            if int(amount) <= 0:
                raise
        except:
            print('Invalid input, negative or zero amount.')
            return
        else:
            self.fund += amount
            # print('Player, {}, added {} to fund. Fund balance:{}'.format(
            #     self.name, amount, self.fund))

    def bet(self, amount):
        # assuming amount is int
        try:
            if int(amount) <= 0 or int(amount) > self.fund:
                raise
        except:
            print('Invalid input, insufficient fund, negative or zero amount.')
            return
        else:
            print('Player, {}, betting {}.'.format(self.name, amount))
            self.fund -= amount
            self.betamount = amount
            return amount

    def clear_card(self):
        self.card = []

    def __str__(self):
        # __str__ has to return string
        return 'Player, {}, currently has fund balance: {}.'.format(self.name, self.fund)


class Dealer(Player):
    def __init__(self):
        self.name = 'Computer'
        self.fund = 99999
        self.card = []
        self.betamount = 0
        self.busted = False

    def bet(self, amount):
        try:
            if int(amount) <= 0 or int(amount) > self.fund:
                raise
        except:
            print('Invalid input, insufficient fund, negative or zero amount.')
            return
        else:
            print('Player, {}, betting {}.'.format(self.name, amount))
            self.betamount = amount
            return amount


def calculate_best_sum(current_player):
    if 1 in current_player.card:
        # A as 1
        sum_A1 = sum([10 if v > 10 else v for v in current_player.card])
        # A as 11
        sum_A11 = sum([10 if v > 10 else 11 if v ==
                       1 else v for v in current_player.card])
        if sum_A11 <= 21:
            best_sum = sum_A11
        else:
            best_sum = sum_A1
    else:
        best_sum = sum([10 if v > 10 else v for v in current_player.card])
    return best_sum


def check_blackjack(current_player):
    return len(current_player.card) == 2 and calculate_best_sum(current_player) == 21


def hit(current_player, deck):
    current_player.add_card(deck.get_card())


def stand(current_player):
    pass


def show_banner():
    print("""
    ____  __    ___   ________ __        _____   ________ __
   / __ )/ /   /   | / ____/ //_/       / /   | / ____/ //_/
  / __  / /   / /| |/ /   / ,<     __  / / /| |/ /   / ,<
 / /_/ / /___/ ___ / /___/ /| |   / /_/ / ___ / /___/ /| |
/_____/_____/_/  |_\____/_/ |_|   \____/_/  |_\____/_/ |_|
    """)

def start_game():
    # Create a new deck
    gamedeck = Deck()

    # Create a new dealer
    dealer = Dealer()

    # Create a new player with currently arbitrary values.
    player1_name = 'Human'
    player1_fund = 1000
    player1 = Player(player1_name, player1_fund)

    keep_play = 'y'
    while keep_play == 'y':
        os.system('cls')
        show_banner()
        # deal two cards to the dealer
        hit(dealer, gamedeck)
        hit(dealer, gamedeck)
        # deal two cards to the player
        hit(player1, gamedeck)
        hit(player1, gamedeck)
        players = [player1]
        for player in players:
            print('\n')
            print('Player\'s turn! Current fund: {}.'.format(player.fund))
            print('*****************************')
            player.bet(int(input('How much would you like to bet?')))
            if check_blackjack(player1):
                player1.add_fund(player1.betamount * 2.5)
                return "Player, {}, wins by blackjack! Payout is {}.".format(player1.name, player1.betamount * 2.5)
            print(' - '.join(map(str, player.card)))
            print('Current score: {}'.format(calculate_best_sum(player)))
            print(player)
            # player getting cards.
            while input('h for hit; other keys for stand.') == 'h':
                print('\n>>>Player Hit!')
                hit(player, gamedeck)
                print(' - '.join(map(str, player.card)))
                print('Current score: {}'.format(calculate_best_sum(player)))
                if calculate_best_sum(player) > 21:
                    player.busted = True
                    print('Turn Over. {} LOST - BUST!!!!'.format(player.name))
                    break
            else:
                print('\n>>>Player Stand!')
                print(' - '.join(map(str, player.card)))
                print('Current score: {}'.format(calculate_best_sum(player)))
                print(player)
                break

        print('\n\n\n')
        print('Dealer\'s turn!')
        print('*****************************')

        if player1.busted == False:
            print(' - '.join(map(str, dealer.card)))
            print('Current score: {}'.format(calculate_best_sum(dealer)))
            while calculate_best_sum(dealer) <= 17 and dealer.busted == False:
                print('\n>>>Dealer Hit!')
                hit(dealer, gamedeck)
                print(' - '.join(map(str, dealer.card)))
                print('Dealer current score: {}'.format(
                    calculate_best_sum(dealer)))
                if calculate_best_sum(dealer) > 21:
                    dealer.busted = True
                    print('Turn Over. Player Won. {} BUST.'.format(dealer.name))
            if dealer.busted == True:
                for player in players:
                    if not player.busted:
                        player.add_fund(player.betamount * 2)
                        print('Player, {},wins payout: {}'.format(
                            player.name, player.betamount))
                        print(player)
            else:
                for player in players:
                    if not player.busted and calculate_best_sum(player) > calculate_best_sum(dealer):
                        player.add_fund(player.betamount * 2)
                        print('Player, {},wins payout: {}'.format(
                            player.name, player.betamount))
                        print(player)
                    else:
                        print(('Player, {}, didn\'t win.'.format(player.name)))
                        print(player)
        else:
            print('All players busted already.')
        dealer.clear_card()
        dealer.busted = False
        player1.clear_card()
        player1.busted = False
        keep_play = input('Continue(y/n)')


def main():
    start_game()


if __name__ == "__main__":
    main()
